#!/usr/bin/env python3

import argparse
import logging
import sys
import collections


import i3ipc
import ravel
import xcffib
import xcffib.randr
import xcffib.dpms
import xcffib.xproto

# python stdlib
import functools
import asyncio

from systemd import daemon, journal


from i3ipc.aio import Connection
CommandEvent = collections.namedtuple("CommandEvent", ["name"])

# StartEvent --> executed when this daemon starts up
StartEvent = object()


logger = logging.getLogger("i3-companion")

def static(**kwargs):
    """Define static variables for the event handler."""

    def decorator(fn):
        fn.__dict__.update(kwargs)
        return fn

    return decorator


# Events for @on decorator
DBusSignal = collections.namedtuple(
    "DBusSignal",
    ["interface", "member", "signature", "system", "path", "onlyif"],
    defaults=(True, "/", None),
)

I3Event = i3ipc.Event

@static(functions={})
def on(*events):
    """Tag events that should be provided to the function."""

    def decorator(fn):
        @functools.wraps(fn)
        def wrapper(*args, **kwargs):
            return fn(*args, **kwargs)

        on.functions[fn] = events
        return wrapper

    return decorator
@on(
    DBusSignal(
        interface="org.freedesktop.login1.Manager",
        member="PrepareForSleep",
        signature="b",
    ),
)

@on(StartEvent)
async def on_start_event(i3, event):
    logger.info("MY START EVENT WAS TRIGERRED")

@on(I3Event.WINDOW_NEW)
async def on_window_new(i3, event):
    logger.info("moved window")

async def on_resume(i3, event, path, sleeping):
    """Switch monitor on when resuming from sleep."""
    if not sleeping:
        logger.info("resume from sleep")
        dpms = i3.x11(xcffib.dpms.key)
        if dpms.Info().reply().power_level != 0:
            dpms.ForceLevel(0)
            i3.x11.flush()


async def main(options):
    i3 = await Connection(auto_reconnect=True).connect()
    i3.session_bus = await ravel.session_bus_async()
    i3.system_bus = await ravel.system_bus_async()
    i3.x11 = xcffib.connect()

    # Regular events
    for fn, events in on.functions.items():
        for event in events:
            if isinstance(event, I3Event):

                def wrapping(fn, event):
                    async def wrapped(i3, event):
                        logger.debug("received i3 event %s for %s", event, fn)
                        return await fn(i3, event)

                    return wrapped

                i3.on(event, wrapping(fn, event))

    # React to some bindings
    async def binding_event(i3, event):
        """Process a binding event."""
        # We only processes it when it is a nop command and we use
        # this mechanism as an IPC mechanism. The alternative would be
        # to use ticks but we would need to spawn an i3-msg process
        # for that.
        for cmd in event.binding.command.split(";"):
            cmd = cmd.strip()
            if not cmd.startswith("nop "):
                continue
            cmd = cmd[4:].strip(" \"'")
            if not cmd:
                continue
            kind = cmd.split(":")[0]
            for fn, events in on.functions.items():
                for e in events:
                    if isinstance(e, CommandEvent) and e.name == kind:
                        logger.debug("received command event %s for %s", event, fn)
                        await fn(i3, cmd)

    i3.on(I3Event.BINDING, binding_event)

    # React to ticks
    async def tick_event(i3, event):
        """Process tick events."""
        kind = event.payload.split(":")[0]
        for fn, events in on.functions.items():
            for e in events:
                if isinstance(e, CommandEvent) and e.name == kind:
                    logger.debug("received command event %s for %s", event, fn)
                    await fn(i3, event.payload)

    i3.on(I3Event.TICK, tick_event)

    # Listen to DBus events
    for fn, events in on.functions.items():
        for event in events:
            if isinstance(event, DBusSignal):
                bus = i3.system_bus if event.system else i3.session_bus

                def wrapping(fn, event):
                    @ravel.signal(
                        name=event.member,
                        in_signature=event.signature,
                        path_keyword="path",
                        args_keyword="args",
                    )
                    async def wrapped(path, args):
                        if event.onlyif is not None and not event.onlyif(args):
                            logger.debug(
                                "received DBus event for %s, not interested", fn
                            )
                            return
                        logger.debug("received DBus event %s for %s", event, fn)
                        return await fn(i3, event, path, *args)

                    return wrapped

                bus.listen_signal(
                    path=event.path,
                    fallback=True,
                    interface=event.interface,
                    name=event.member,
                    func=wrapping(fn, event),
                )

    # Run events that should run on start
    start_tasks = []
    for fn, events in on.functions.items():
        for event in events:
            if event is StartEvent:
                start_tasks.append(asyncio.create_task(fn(i3, event)))

    # daemon.notify("READY=1")
    await i3.main()




if __name__ == "__main__":
    # Parse
    # description = sys.modules[__name__].__doc__
    # for fn, events in on.functions.items():
        # description += f" {fn.__doc__}"
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--debug",
        "-d",
        action="store_true",
        default=False,
        help="enable debugging",
    )
    options = parser.parse_args()

    # Logging
    root = logging.getLogger("")
    root.setLevel(logging.WARNING)
    logger.setLevel(options.debug and logging.DEBUG or logging.INFO)
    # if stderr is open and connected to a tty like interface
    # if sys.stderr.isatty():
    ch = logging.StreamHandler()
    ch.setFormatter(logging.Formatter("%(levelname)s: %(message)s"))
    root.addHandler(ch)
    # else:
        # root.addHandler(journal.JournaldLogHandler())

    try:
        asyncio.run(main(options))
    except Exception as e:
        logger.exception("%s", e)
        sys.exit(1)
    sys.exit(0)

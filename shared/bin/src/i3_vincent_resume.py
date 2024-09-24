import ravel
import xcffib
import asyncio
import xcffib.dpms
import xcffib.xproto
from i3ipc.aio import Connection

async def on_resume(i3):
    """Switch monitor on when resuming from sleep."""
    print("resumed")
    dpms = i3.x11(xcffib.dpms.key)
    # if dpms.Info().reply().power_level != 0:
    dpms.ForceLevel(0)
    i3.x11.flush()

async def main():
    i3 = await Connection(auto_reconnect=True).connect()
    i3.session_bus = await ravel.session_bus_async()
    i3.system_bus = await ravel.system_bus_async()
    i3.x11 = xcffib.connect()
    await on_resume(i3)


if __name__ == "__main__":
    asyncio.run(main())

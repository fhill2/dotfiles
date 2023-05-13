#!/usr/bin/env python3

from f.i3.window import open_wait_window
from f.i3.events import subscribe
from f.util import log, dump_out


log("i3_window_startup")
# for now, just start a terminal
# i3_preview_startup.py is dependant on this, otherwise workspace 7 is focused on first startup
def on_workspace_one_init(self, data):
    log("on workspace one init")
    log(dump_out(data))
    # log(dump_out(data.ipc_data["name"]))

    # if data.ipc_data["name"] == "1":
#
        # log("i3_window_startup - launched kitty")
        # open_wait_window("kitty")
#
subscribe("WORKSPACE_INIT", on_workspace_one_init)

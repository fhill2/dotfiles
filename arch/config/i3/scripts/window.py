from f.i3.events import subscribe_until

from i3ipc import Connection, Event

import json
i3 = Connection()

def open_wait_window(cmd, cli=None):
    """opens a window and blocks until the window new event is received at ipc"""
    def open_window():
        print("this was fired")
        i3.command(f"exec {cmd}")
    con = subscribe_until("WINDOW_NEW", cb=open_window, cli=cli)
    return con

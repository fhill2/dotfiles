#!/usr/bin/env python
import sys
from i3ipc import Connection, Event
from f.util import dump
# opens a window, and blocks until the window is ready to be manipulated by i3
if __name__ == '__main__':
    i3 = Connection()
    def on_window(self, e):
        print(e.container.ipc_data["window"])
        exit()
    i3.on(Event.WINDOW_NEW, on_window)
    cmd = " ".join(sys.argv.copy()[1:])
    i3.command(f"exec {cmd}")
    i3.main()

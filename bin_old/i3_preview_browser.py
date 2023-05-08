#!/usr/bin/env python3

import json, sys

from f.util import run_sh
from f.native_client import send_message
# all_visible_workspace_ids = run_sh("swaymsg -t get_workspaces | jq -r '.[] | select(.visible == true) | .id'")
# focused_ws_id = run_sh("swaymsg -t get_workspaces | jq -r '.[] | select(.focused == true) | .id'")[0]

# preview cannot rely on window title, as when the firefox browser preview window is open
# the browser window title hasnt been changed yet
# Not using this anymore - as web extensions cannot programatically load file:/// local urls in the browser

def pick_firefox_window():
    """extracts firefox window ID from i3 titlebar on the same monitor as the currently focused window"""
    all_visible_firefox_windows = json.loads("".join(run_sh("sway_print_tree all_windows_on_visible_workspaces | jq -r 'select(.window_properties.class == \"firefox-nightly\" and .window_type == \"normal\")' | jq -s '.'")))
    focused_output = run_sh("sway_print_tree focused | jq -r '.output'")[0]

    def extract_id(name):
        # return name.replace(" — Firefox Nightly", "").split("-")[-1].strip()
        return name.split(" ")[0].strip()

    for browser_win in all_visible_firefox_windows:
        # get output monitor of currently focused window
        # pick the firefox window existing on the same window to show preview (if it exists)
        if browser_win["output"] == focused_output:
            return extract_id(browser_win["name"])
    return extract_id(all_visible_firefox_windows[0]["name"])





# def handle(line):
    # print(pick_firefox_window())
    # send_message("preview", { "path": line, "target" : pick_firefox_window()})


# def repeat_test():
#     try: 
#         send_message("test", "")
#     except:
#         repeat_test()
#
if __name__ == '__main__':
    if len(sys.argv) < 1:
        print("pass in path as first argument")
        exit()
    # as this message is fired before firefox has completed setup
    # TODO: probably better to have the socket open on the daemon side, not on the native messaging host
    send_message("preview", { "url": sys.argv[1], "id" : pick_firefox_window()})
        

# FIFO="/home/f1/tmp/preview_browser_win.fifo"
# https://stackoverflow.com/a/39089792
# continuously reopen the pipe

# while True:
#     with open(FIFO, 'r') as pipe:
#         handle(pipe.read())
#
# while True:
#     print("Opening FIFO...")
#     with open(FIFO) as fifo:
#         while True:
#             data = fifo.read()
#             handle(data)
#             if len(data) == 0:
#                 print("Writer closed")
#                 break
#             print('Read: "{0}"'.format(data))

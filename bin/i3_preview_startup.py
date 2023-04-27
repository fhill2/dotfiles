#!/usr/bin/env python3

import subprocess
from f.i3.window import open_wait_window
from f.util import dump_out


from i3ipc import Connection, Event
i3 = Connection()

def startup():
    print("i3_preview_startup ran")

# spawn a new terminal on workspace 1
# as when logging in there might be no windows on workspace 1
# which causes workspace 1 to dissapear when switching to workspace 7 to spawn previewer windows
    def iter_tree(c):
        if c.name == "1" and c.type == "workspace":
            if len(c.nodes) == 0:
                print("workspace found, and no container on workspace")
                i3.command("[workspace=1] focus")
                open_wait_window("kitty")
        else: 
            for c in c.nodes:
                iter_tree(c)
    iter_tree(i3.get_tree());

    

    subprocess.run("pkill mpv; sleep 0.1", shell=True)
    # you can change x11 class name of mpv window - could you assign and class name change instead of marks
    # https://mpv.io/manual/master/#window

    # --keep-open=always -> otherwise when previewing images, mpv closes automatically
    # --force-window=immediate -> force mpv to spawn a window and not stay in CLI mode
    # - -> read from stdin - paired with --force-window to force the window to open
    # --geometry -> experimenting with mpv to lock aspect ratio when resizing

    # TODO: change these to async and exec them in the background when i3 starts up
    mpv_cmd = "mpv --autofit-larger=50%x50% --keep-open=always --force-window=immediate -"
    con = open_wait_window(mpv_cmd)
    con.command(f"mark preview_mpv; floating enable; move container to workspace number 7")
    con.command(f'resize set width {50} ppt height {50} ppt')
    con.command('move to position 0 0')

    # setup zathura
    con = open_wait_window("zathura")
    con.command(f"mark preview_zathura; floating enable; move container to workspace number 7")
    con.command(f'resize set width {30} ppt height {80} ppt')
    # setup kitty
    con = open_wait_window("kitty sh -c 'i3_preview_terminal.sh'")
    con.command(f"mark preview_kitty; floating enable; move container to workspace number 7")
    con.command(f'resize set width {30} ppt height {80} ppt')

    i3.command("[workspace=1] focus")

startup()


# wait for workspace new event for workspace 1
# then wait for new window on workspace 1 before executing startup
# this is because this script focuses workspace 7, which removes workspace 1 as there are no windows currently on workspace 1 when starting up
# an alternative would be to startup windows on specific workspaces before running this script, but I don't want this script's functionality to be dependant on that



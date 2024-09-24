# Copyright (c) 2010 Aldo Cortesi
# Copyright (c) 2010, 2014 dequis
# Copyright (c) 2012 Randall Ma
# Copyright (c) 2012-2014 Tycho Andersen
# Copyright (c) 2012 Craig Barnes
# Copyright (c) 2013 horsik
# Copyright (c) 2013 Tao Sauvage
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

from typing import List  # noqa: F401

from libqtile import bar, layout, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
from libqtile import hook

from libqtile.log_utils import logger

# ~/dot/qtile/functions.py
from functions import Function
from colors import colors
from bar import init_bar

# Print every startup into qtile.log - easier to debug
from datetime import datetime
now = datetime.now()
dt_string = now.strftime("%d/%m/%Y %H:%M:%S")
logger.warning("========== QTILE STARTUP ==========")


mod = "mod4"
# terminal = guess_terminal()
terminal = "kitty"

from libqtile.widget import backlight
keys = [
    Key('', 'F2', lazy.spawn('rofi -show drun')),
    Key('', 'F3', lazy.spawn('qtile_kb_rofi')),
    # Switch between windows
    # Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    # Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    # Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    # Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    # Key([mod], "space", lazy.layout.next(),
    #     desc="Move window focus to other window"),

    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    # Key([mod, "shift"], "h", lazy.layout.shuffle_left(),
    #     desc="Move window to the left"),
    # Key([mod, "shift"], "l", lazy.layout.shuffle_right(),
    #     desc="Move window to the right"),
    # Key([mod, "shift"], "j", lazy.layout.shuffle_down(),
    #     desc="Move window down"),
    # Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),

    # column layout only
    #Key([mod, "shift", "control"], "h", lazy.layout.swap_column_left()),
    #Key([mod, "shift", "control"], "l", lazy.layout.swap_column_right()),


    # all Stack window movement under alt+shift+hjkl
    Key([mod], "h",
            lazy.layout.previous(), # Stack
            lazy.layout.left()),    # xmonad-tall
        Key([mod], "l",
            lazy.layout.next(),     # Stack
            lazy.layout.right()),   # xmonad-tall
        Key([mod], "k",
            lazy.layout.up()),
        Key([mod], "j",
            lazy.layout.down()),

        Key([mod, "shift"], "l",
            lazy.layout.client_to_next(), # Stack
            lazy.layout.swap_right()),    # xmonad-tall
        Key([mod, "shift"], "h",
            lazy.layout.client_to_previous(), # Stack
            lazy.layout.swap_left()),    # xmonad-tall


        Key([mod, "shift"], "space",
            lazy.layout.rotate(),
            lazy.layout.flip()),              # xmonad-tall
        Key([mod, "shift"], "k",
            lazy.layout.shuffle_up()),       # Stack, xmonad-tall
        Key([mod, "shift"], "j",
            lazy.layout.shuffle_down()),         # Stack, xmonad-tall

        Key([mod, "shift"], "Return",
                lazy.layout.toggle_split()), # Column
        Key([mod], "m",
            lazy.layout.toggle_maximize()), # Stack
        Key([mod, "control"], "m",
            lazy.layout.maximize()),            # xmonad-tall
        Key([mod, "control"], "n",
            lazy.layout.normalize()),            # xmonad-tall

        Key([mod, "control"], "l",
            lazy.layout.delete(),                # Stack
            #lazy.layout.increase_ratio(),     # Tile
            #lazy.layout.grow()
            ),            # xmonad-tall
        Key([mod, "control"], "h",
       lazy.layout.add(),             # Stack
        #lazy.layout.decrease_ratio(),     # Tile
        #lazy.layout.shrink()
        ),         # xmonad-tall
    Key([mod, "control"], "k",
        lazy.layout.grow(),             # xmonad-tall
        lazy.layout.decrease_nmaster()),    # Tile
    Key([mod, "control"], "j",
        lazy.layout.shrink(),               # xmonad-tall
        lazy.layout.increase_nmaster()),   # Tile


    # Key([mod], "n", lazy.layout.normalize()),

    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    # Key([mod, "control"], "h", lazy.layout.grow_left(),
    #     desc="Grow window to the left"),
    # Key([mod, "control"], "l", lazy.layout.grow_right(),
    #     desc="Grow window to the right"),
    # Key([mod, "control"], "j", lazy.layout.grow_down(),
    #     desc="Grow window down"),
    # Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),

    Key([mod, "shift"], "Return", lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack"),
    # Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),

    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),

    Key([mod, "control"], "r", lazy.restart(), desc="Restart Qtile"),
    #Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    # Key([mod], "r", lazy.spawncmd(),
        # desc="Spawn a command using a prompt widget"),
        #http://docs.qtile.org/en/latest/_modules/libqtile/widget/backlight.html
    Key([], "XF86MonBrightnessUp", lazy.widget['backlight'].change_backlight(backlight.ChangeDirection.UP)),
    Key([],"XF86MonBrightnessDown",lazy.widget['backlight'].change_backlight(backlight.ChangeDirection.DOWN)),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("amixer sset Master 5%+")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("amixer sset Master 5%-")),
    Key([], "XF86AudioMute", lazy.spawn("amixer sset Master toggle")),

    # dropdowns
    Key([mod], "period", Function.dropdown_kill_toggle("omni")),
    Key([mod], "semicolon", lazy.group["scratchpad"].dropdown_toggle("kate")),

    # Key('', "F3", lazy.spawn("sh -c 'echo \"" + show_keys(keys) + "\" | rofi -dmenu -i -mesg \"Keyboard shortcuts\"'"), desc="Print keyboard bindings"),
]



################### SCREENS ####################
screens = [
        # Screen(),
        # Screen(),
        Screen(top=init_bar()),
        # Screen(top=init_bar()),
]

#groups = [Group(i) for i in "123456789"]
groups = [Group(i) for i in "123456789"]

for i in groups:
    keys.extend([
        # mod1 + letter of group = switch to group
        Key([mod], i.name, lazy.group[i.name].toscreen(),
            desc="Switch to group {}".format(i.name)),

        # mod1 + shift + letter of group = switch to & move focused window to group
        Key([mod, "shift"], i.name, lazy.window.togroup(i.name, switch_group=True),
            desc="Switch to & move focused window to group {}".format(i.name)),
        # Or, use below if you prefer not to switch to that group.
        # # mod1 + shift + letter of group = move focused window to group
        # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
        #     desc="move focused window to group {}".format(i.name)),
    ])

# DROPDOWNS
from libqtile.config import ScratchPad, DropDown
groups += [
        ScratchPad(
            "scratchpad",
            dropdowns=[
                # Drop down terminal with tmux session
                # path to gentries has to be absolute, as SCRIPT_DIR doesnt resolve symlinks
                DropDown(
                    "omni",
                    "kitty --title 'omni' zsh -c 'f_tw; zsh'",
                    opacity=1,
                    y=0.0151,
                    height=0.4650,
                    #on_focus_lost_hide=on_focus_lost_hide,
                    on_focus_lost_hide=False,
                    warp_pointer=False,
                ),
                DropDown(
                    "kate",
                    "kate",
                    opacity=1,
                    y=0.75,
                    width=0.5,
                    height=0.25,
                    on_focus_lost_hide=False,
                    warp_pointer=False,
                ),
            ],
        ),
    ]

layouts = [
    layout.Columns(border_focus_stack=['#d75f5f', '#8f3d3d'], border_width=4),
    layout.Max(),
    # Try more layouts by unleashing below layouts.
    layout.Stack(num_stacks=3),
    # layout.Bsp(),
    # layout.Matrix(),
    layout.MonadTall(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    layout.Tile(),
    layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]





# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
         start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
         start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: List
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating(float_rules=[
    # Run the utility of `xprop` to see the wm class and name of an X client.
    *layout.Floating.default_float_rules,
    Match(wm_class='confirmreset'),  # gitk
    Match(wm_class='makebranch'),  # gitk
    Match(wm_class='maketag'),  # gitk
    Match(wm_class='ssh-askpass'),  # ssh-askpass
    Match(title='branchdialog'),  # gitk
    Match(title='pinentry'),  # GPG key password entry
])
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

wmname = "LG3D"


import subprocess
def execute_once(process):
    subprocess.Popen(process.split())

@hook.subscribe.startup_once
def autostart():
    execute_once('dunst')
    execute_once('xmousepasteblock')
    execute_once('redshift -P -O 4900')
    execute_once('autorandr --load monitor_left')
    # execute_once('/home/f1/dot/qtile/autostart.sh')
    execute_once("sudo kmonad ~/dot/kmonad/config.kbd")

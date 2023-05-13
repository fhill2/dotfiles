import sys
#sys.path.append(r'/home/f1/.nix-profile/lib/python3.9/site-packages')
sys.path.append(r'/home/f1/dev/cl/python/standalone')

from typing import List  # noqa: F401

from libqtile import layout, qtile
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
#from libqtile.utils import guess_terminal
from libqtile import hook
import os
import subprocess,re

#from groups import init_groups
from keys import init_keys, init_group_keys
from screens import init_screens
from dropdown import init_dropdown, init_dropdown_keys
from widgets import init_widgets
from libqtile.log_utils import logger

from functions import Function
# sys.path += ["whatever"]

#terminal = guess_terminal()

def dump(obj):
    import inspect
    x = []
    logger.error("===================== methods ====================")
    for i in inspect.getmembers(obj):
        if not i[0].startswith('_'):
            if not inspect.ismethod(i[1]):
                x.append(i)
            else:
                print(i)
    logger.error("===================== props ====================")
    for props in x:
        logger.error(props)

try:
    import aiomanhole
except ImportError:
    aiomanhole = None



#def log(*args, **kwargs):
#    f = open("/home/f1/logs/myqtile.log",'w')
#    print(*args, **kwargs, file=f)

#import builtins
#builtins.log = log
#builtins.printl = log
#import init
#builtins.dump = init.dump
#from libqtile.log_utils import logger
#def log(*args, **kwargs):
#    logger.warning(*args, **kwargs)

#def dump(*args, **kwargs):
#    qtile_dump(*args, **kwargs)

from datetime import datetime, date
now = datetime.now()
today = date.today()

#log("Config Reload at ")
#log(now)
import sys


from libqtile.config import Group, ScratchPad, DropDown, Key
from libqtile.command import lazy


# groups = init_groups()
keys = init_keys()

# APPEND
#keys += init_group_keys()
keys += init_dropdown_keys()


mod = "mod4"

layouts = [
    layout.Columns(border_focus_stack=['#d75f5f', '#8f3d3d'], border_width=4),
    layout.Max(),
    layout.Floating(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadTall(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]
widget_defaults = dict(
    font='sans',
    fontsize=12,
    padding=3,
)
#widgets = init_widgets()
extension_defaults = widget_defaults.copy()

screens = init_screens()

# Drag floating layouts.
mouse = [
    Drag(['mod1'], "Button1", lazy.window.set_position_floating(),
        start=lazy.window.get_position()),
    Drag(['mod1'], "Button3", lazy.window.set_size_floating(),
        start=lazy.window.get_size()),
    Click(['mod1'], "Button2", lazy.window.bring_to_front())
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
    Match(title='nemo-preview-start'),  # GPG key password entry
])
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

auto_minimize = True

wmname = "LG3D"

@hook.subscribe.startup_complete
def set_manhole():
    aiomanhole.start_manhole(port=7113, namespace={"qtile": qtile})



# groups = []
# for i in ["a", "s", "d", "f", "u", "i", "o", "p"]:
#     groups.append(Group(i))
#     keys.append(
#         Key([mod], i, lazy.group[i].toscreen())
#     )
#     keys.append(
#         Key([mod, "shift"], i, lazy.window.togroup(i))
#     )

# groups += init_dropdown()
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


# arkchar.py qtile examples
import subprocess, re
def is_running(process):
    s = subprocess.Popen(["ps", "axuw"], stdout=subprocess.PIPE)
    for x in s.stdout:
        if re.search(process, x):
            return True
    return False

def execute_once(process):
    subprocess.Popen(process.split())

@hook.subscribe.startup_once
def autostart():
    execute_once('dunst')
    execute_once('xmousepasteblock')
    execute_once('redshift -P -O 4900')
    execute_once('/home/f1/dot/qtile/autostart.sh')


    
# @hook.subscribe.screens_reconfigured
# def screens_reconfigured():
    #qtile.screens[1].set_group(qtile.groups_map["alt1"])


#
# @hook.subscribe.client_new
# def func(window):
#     c_wm_class = window.window.get_wm_class()[0]
#     #if window.window.get_wm_class()[1] == 'nemo-preview-start':
#     if c_wm_class == "nemo-preview-start":
#         window.floating = True
#         window.set_size_floating(640,360)
#         window.set_position_floating(1600,1800)
#



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

from groups import init_groups
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


groups = init_groups()
keys = init_keys()

# APPEND
#keys += init_group_keys()
groups += init_dropdown()
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

# ----- END DEFAULT CONFIG ----- 


@hook.subscribe.startup_once
def autostart():
    #logger.error(qtile.screens)
    #qtile.screens[1].set_group(qtile.groups_map["alt1"])
    # put output of of autostart.sh into ~/.local/share/qtile/qtile.log
    #https://github.com/qtile/qtile/issues/1169
    # if os.environ['DISPLAY'] == ':0': 
    #     output = subprocess.check_output(
    #         os.path.expanduser('~/dot//qtile/autostart.sh'),
    #         shell=True
    #     ).decode('utf-8')
    #     logger.error(output)

    # startup apps have to be started like this
    # https://github.com/qtile/qtile/issues/685#issuecomment-445555560
    # when starting apps in bash autostart.sh with &, any errors can cause qtile not to start up
    processes = [
        ['dunst'],
        ['xmousepasteblock'],  
        ['redshift', '-P', '-O', '4900'],
        #['f_start_nemo_preview.sh'], # I think this might be causing monitor freeze
        #"xrandr --output DP-0 --off --output DP-1 --off --output DP-2 --off --output DP-3 --off --output DP-4 --mode 3840x2160 --pos 0x0 --rotate normal --output DP-5 --off --output DP-6 --off --output DP-7 --off --output eDP-1-1 --mode 2560x1600 --pos 3840x560 --rotate normal --output DP-1-1 --off --output DP-1-2 --off --output DP-1-3 --off --output DP-1-4 --off".split(" "),
        #['xset', 'dpms', 'force', 'off'],
        #['xset', '-dpms'],
    ]
    for p in processes:
        subprocess.Popen(p)

    
@hook.subscribe.screens_reconfigured
def screens_reconfigured():
    # qtile DEFAULT is reconfigure_screens=True -> 
    # when any xrandr event happens, qtile reconfigures the internal screen setup, and then fires this hook
    #logger.error(qtile.screens)
    qtile.screens[1].set_group(qtile.groups_map["alt1"])



@hook.subscribe.client_new
def func(window):
    c_wm_class = window.window.get_wm_class()[0]
    #if window.window.get_wm_class()[1] == 'nemo-preview-start':
    if c_wm_class == "nemo-preview-start":
        window.floating = True
        window.set_size_floating(640,360)
        window.set_position_floating(1600,1800)




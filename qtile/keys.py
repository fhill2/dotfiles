from libqtile.config import Key
from libqtile.command import lazy

from libqtile.widget import backlight


from functions import Function


def go_to_group(group):
    def f(qtile):
        if group in '1256':
            qtile.cmd_to_screen(0)
            qtile.groupMap[group].cmd_toscreen()
        elif group in '3478':
            qtile.cmd_to_screen(1)
            qtile.groupMap[group].cmd_toscreen()
    return f


def init_keys():

   mod = "mod4" # this was mod1 -  xmodmap in CLI to view what you can type in here
   return [
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(),
        desc="Move window focus to other window"),

    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(),
        desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(),
        desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(),
        desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),

    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(),
        desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(),
        desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(),
        desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key([mod, "shift"], "Return", lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack"),
    Key([mod], "Return", lazy.spawn("kitty"), desc="Launch terminal"),

    # Toggle between different layouts as defined below
    #Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),

    #Key([mod, "shift"], "r", lazy.restart(), desc="Restart Qtile"),
    #Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
   
    # focus specific groups
    Key([mod], "1", Function.screen_to_group(0, "main1") , desc="main screen --> main1 group"),
    Key([mod], "2", Function.screen_to_group(0, "main2") , desc="main screen --> main2 group"),
    Key([mod], "3", Function.screen_to_group(1, "alt1") , desc="alt screen --> alt1 group"),
    Key([mod], "4", Function.screen_to_group(1, "alt2") , desc="alt screen --> alt2 group"),
    Key([mod], "d", Function.screen_to_group(1, "DISC") , desc="alt screen --> discord group"),
    Key([mod], "5", Function.screen_to_group(1, "DISC") , desc="alt screen --> discord group"),
    #Key([mod], "Tab", Function.screen_to_group(0, "WIN") , desc="main screen --> win group"),
    
    # move window to specific group
    Key([mod, "shift"], "1", lazy.window.togroup("main1") , desc="move active window to main1 group"),
    Key([mod, "shift"], "2", lazy.window.togroup("main2") , desc="move active window to main2 group"),
    Key([mod, "shift"], "3", lazy.window.togroup("alt1") , desc="move active window to alt1 group"),
    Key([mod, "shift"], "4", lazy.window.togroup("alt2") , desc="move active window to alt2 group"),
    Key([mod, "shift"], "d", lazy.window.togroup("DISC") , desc="move active window to DISC group"),
    Key([mod, "shift"], "5", lazy.window.togroup("DISC") , desc="move active window to DISC group"),
    #Key([mod, "shift"], "Tab", lazy.window.togroup("WIN") , desc="move active window to WIN group"),
    
    Key('', 'F2', lazy.spawn('rofi -show drun')),
#Key([mod], "F1", lazy.spawn("/home/f1/bin/qtile_kb_rofi.sh -c /home/f1/dev/dot/home-manager/config/qtile/config.py"), desc="Print keyboard bindings"),


    # laptop only fn+ keys (there is no function key on corsair)
    # corsair external keyboard multimedia keys are set on ckb-next software
    # LIST OF KEYS:
    # https://wiki.archlinux.org/title/Dell_XPS_13_(7390)


    #http://docs.qtile.org/en/latest/_modules/libqtile/widget/backlight.html
    Key([], "XF86MonBrightnessUp", lazy.widget['backlight'].change_backlight(backlight.ChangeDirection.UP)),
    Key([],"XF86MonBrightnessDown",lazy.widget['backlight'].change_backlight(backlight.ChangeDirection.DOWN)),

    Key([], "XF86AudioRaiseVolume", lazy.spawn("amixer sset Master 5%+")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("amixer sset Master 5%-")),
    Key([], "XF86AudioMute", lazy.spawn("amixer sset Master toggle")),


]

def init_group_keys():
    mod = "mod4"
  
    keys = [
    # # focusing each specific group
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    ]

    #for i in '1234567890':
    #  keys.append(Key([mod], i, lazy.function(go_to_group(i)))),
    #  keys.append(Key([mod, 'shift'], i, lazy.window.togroup(i)))
    return keys




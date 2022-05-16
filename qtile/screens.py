from libqtile.config import Screen
from libqtile.bar import Bar
from libqtile import bar, layout, widget




def init_screens():
    return [
        Screen(
        bottom=bar.Bar(
            [
                widget.CurrentLayout(),
                widget.Sep(linewidth=2, size_percent=100, padding=12),
                widget.GroupBox(visible_groups=['main1', 'main2', 'WIN']),
                widget.Sep(linewidth=2, size_percent=100, padding=12),
                widget.Prompt(),
                widget.WindowName(),
                # widget.Chord(
                #     chords_colors={
                #         'launch': ("#ff0000", "#ffffff"),
                #     },
                #     name_transform=lambda name: name.upper(),
                # ),
                #widget.TextBox("default config", name="default"),
               # widget.TextBox("Press &lt;M-r&gt; to spawn", foreground="#d75f5f"),
                widget.BatteryIcon(),
                #widget.Backlight(backlight_name='intel_backlight'),
                widget.Wlan(interface='wlp0s20f3'),
                widget.Volume(),
                widget.Systray(),
                widget.ThermalSensor(),
                widget.Clock(format='%Y-%m-%d %a %I:%M %p'),
                #widget.QuickExit(),
            ],
            24,
        ),
    ),
        Screen(
        bottom=bar.Bar(
            [
                widget.CurrentLayout(),
                widget.Sep(linewidth=2, size_percent=100, padding=12),
                widget.GroupBox(visible_groups=['alt1', 'alt2', 'DISC']),
                widget.Sep(linewidth=2, size_percent=100, padding=12),
                widget.Prompt(),
                widget.WindowName(),
                # widget.Chord(
                #     chords_colors={
                #         'launch': ("#ff0000", "#ffffff"),
                #     },
                #     name_transform=lambda name: name.upper(),
                # ),
                #widget.TextBox("default config", name="default"),
                #widget.TextBox("Press &lt;M-r&gt; to spawn", foreground="#d75f5f"),
                #widget.Systray(),
                widget.BatteryIcon(),
                widget.Backlight(backlight_name='intel_backlight', change_command='/usr/bin/light -s sysfs/backlight/intel_backlight -S {0}'),
                widget.Wlan(interface='wlp0s20f3'),
                widget.Volume(),
                widget.ThermalSensor(),
                widget.Clock(format='%Y-%m-%d %a %I:%M %p'),
                #widget.QuickExit(),
            ],
            24,
        ),
    ),

]
 

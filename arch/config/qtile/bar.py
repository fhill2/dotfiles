from colors import colors

from libqtile import bar, widget
import subprocess

widget_defaults = dict(
    font='DejaVuSansMono Nerd Font Mono',
    fontsize=18,
    foreground=colors["fg"],
    background=colors["bg"],
    padding=15,
)


layout = widget.CurrentLayout(
                **widget_defaults,
                )

groupbox = widget.GroupBox(
                **widget_defaults,
                highlight_method="text", # ‘border’, ‘block’, ‘text’, or ‘line’
                # block_highlight_text_color=colors["fg"],
                active=colors["fg"], # non focused 
                rounded=False,
                # highlight_color=colors["bg_light"],
                # block_hightlight_text_color=colors["fg"],
                urgent_alert_method="line",
                # urgent_text=colors["color1"],
                # urgent_border=colors["color1"],
                disable_drag=True,
                use_mouse_wheel=False,
                hide_unused=True,
                spacing=3,
                this_current_screen_border=colors["bg_light"],
                center_aligned=True
                )

windowname = widget.WindowName(
                **widget_defaults,
                format='{name}',
            )
#
#
systray = widget.Systray(
        **widget_defaults,
        # "theme_path": "rose-pine-gtk", 
        )
cpu = widget.CPU(
                **widget_defaults,
                format="{load_percent}%", 
                fmt=" {}"
                )

memory = widget.Memory(
        **widget_defaults,
        format='{MemPercent}%',
        fmt="溜 {}",
         interval=1.0
                )


battery = widget.Battery(
**widget_defaults,
                # foreground=colors["bg"],
                # background=colors["color4"],
                # foreground=colors["fg"],
                # low_foreground=colors["color1"],
                # low_background=None,
                # low_percentage=0.30,
                charge_char="",
                discharge_char="",
                full_char="",
                empty_char="X",
                unknown_char="?",
                format="{char} {percent:2.0%}",
                fmt="{}",
                show_short_text=False,
                )

wlan = widget.Wlan(
**widget_defaults,
        interface='wlp0s20f3',
        format="{percent:2.0%} {essid}",
        fmt=" {}"
        )

volume = widget.Volume(
**widget_defaults,
fmt="蓼 {}"
        )


backlight = widget.Backlight(
        **widget_defaults,
        # format="盛 {percent:2.0%}",
        fmt="盛 {}",
        backlight_name='intel_backlight',
        )

sensor = widget.ThermalSensor(
        **widget_defaults,
        fmt=" {}",
        tag_sensor="Core 0",
        )

date = widget.Clock(
                **widget_defaults,
                format='%m/%d/%Y',
                fmt=" {}"
                )

time = widget.Clock(
                **widget_defaults,
                format='%I:%M %p',
                fmt=" {}"
                )

spacer = widget.Spacer(**widget_defaults, length=23)
                # )
def widgetlist():
    return [
          layout,
          spacer,
          groupbox,
          spacer,
          windowname,
          spacer,
          systray,
          spacer,
          cpu,
          spacer,
          memory,
          spacer,
          battery,
          spacer,
          wlan,
          spacer,
          volume,
          spacer,
          backlight,
          spacer,
          sensor,
          spacer,
          time,
          spacer,
          date,
            ]

def init_bar():
  return bar.Bar(widgetlist(),
    40, # size of bar
    )



# old bar 2


# time_spacer = widget.TextBox(
#                     **spacer_defaults,
#                     background=colors["color2"], foreground=colors["color1"],)
# time = widget.Clock(
# **widget_defaults,
#                     background=colors["bg"],
#                     foreground=colors["bg_light"],
#                     format="%H:%M - %d/%m/%Y",
#                     update_interval=60.0

# # old bar
# bottom=bar.Bar(
#             [
#                 widget.CurrentLayout(),
#                 widget.Sep(linewidth=2, size_percent=100, padding=12),
#                 widget.GroupBox(),
#                 widget.Sep(linewidth=2, size_percent=100, padding=12),
#                 widget.Prompt(),
#                 widget.WindowName(),
#                 # widget.Chord(
#                 #     chords_colors={
#                 #         'launch': ("#ff0000", "#ffffff"),
#                 #     },
#                 #     name_transform=lambda name: name.upper(),
#                 # ),
#                 #widget.TextBox("default config", name="default"),
#                # widget.TextBox("Press &lt;M-r&gt; to spawn", foreground="#d75f5f"),
#                 widget.BatteryIcon(),
#                 #widget.Backlight(backlight_name='intel_backlight'),
#                 widget.Wlan(interface='wlp0s20f3'),
#                 widget.Volume(),
#                 widget.Systray(),
#                 widget.ThermalSensor(),
#                 widget.Clock(format='%Y-%m-%d %a %I:%M %p'),
#                 #widget.QuickExit(),
#             ],
#             24,
#         ),
# bottom=bar.Bar(
#             [
#                 widget.CurrentLayout(),
#                 widget.Sep(linewidth=2, size_percent=100, padding=12),
#                 widget.GroupBox(),
#                 widget.Sep(linewidth=2, size_percent=100, padding=12),
#                 widget.Prompt(),
#                 widget.WindowName(),
#                 # widget.Chord(
#                 #     chords_colors={
#                 #         'launch': ("#ff0000", "#ffffff"),
#                 #     },
#                 #     name_transform=lambda name: name.upper(),
#                 # ),
#                 #widget.TextBox("default config", name="default"),
#                 #widget.TextBox("Press &lt;M-r&gt; to spawn", foreground="#d75f5f"),
#                 #widget.Systray(),
#                 widget.BatteryIcon(),
#                 widget.Backlight(backlight_name='intel_backlight', change_command='/usr/bin/light -s sysfs/backlight/intel_backlight -S {0}'),
#                 widget.Wlan(interface='wlp0s20f3'),
#                 widget.Volume(),
#                 widget.ThermalSensor(),
#                 widget.Clock(format='%Y-%m-%d %a %I:%M %p'),
#                 #widget.QuickExit(),
#             ],
#             24,
#         ),
#

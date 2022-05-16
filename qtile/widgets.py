# WIDGET CONFIG ISNT DONE HERE - DONT KNOW WHY THIS IS HERE
# WIDGET CONFIG IS AT: screens.py
from libqtile.widget import (
    GroupBox,
    Prompt,
    WindowName,
    TextBox,
    Net,
    CurrentLayout,
    # CurrentLayoutIcon,
    CheckUpdates,
    Systray,
    # CapsNumLockIndicator,
    TaskList,
    # Battery,
    ThermalSensor,
    Memory,
    Clock
)


def init_widgets():
    wl = [] 
    wl += [GroupBox()]
    wl += [Clock()]
    return wl

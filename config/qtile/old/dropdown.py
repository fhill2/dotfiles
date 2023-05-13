from os import environ

from libqtile.config import ScratchPad, DropDown, Key
from libqtile.command import lazy


def init_dropdown():
    # Configuration
    height = 0.4650
    y_position = 0.0151
    warp_pointer = False
    on_focus_lost_hide = True
    opacity = 1

    return [
        ScratchPad(
            "scratchpad",
            dropdowns=[
                # Drop down terminal with tmux session
                # path to gentries has to be absolute, as SCRIPT_DIR doesnt resolve symlinks
                DropDown(
                    "omni",
                    "kitty --title 'omni' zsh -c 'f_tw; zsh'",
                    opacity=opacity,
                    y=y_position,
                    height=height,
                    #on_focus_lost_hide=on_focus_lost_hide,
                    on_focus_lost_hide=False,
                    warp_pointer=warp_pointer,
                ),
                DropDown(
                    "kate",
                    "kate",
                    opacity=opacity,
                    y=0.75,
                    width=0.5,
                    height=0.25,
                    on_focus_lost_hide=False,
                    warp_pointer=warp_pointer,
                ),
            ],
        ),
    ]

    # return [
    #         ScratchPad("scratchpad",
    #             dropdowns = [
    #                 DropDown(
    #                     "dropdown",
    #                     "kitty fzf",
    #                     opacity = opacity,
    #                     y = y_position,
    #                     height = height,
    #                     on_focus_lost_hide = on_focus_lost_hide,
    #                     warp_pointer = warp_pointer)
    #                 ]
    #             ),
    #         ]



from functions import Function
def init_dropdown_keys():
    # Key alias
    mod = "mod4"

    return [
         #Key([mod], "comma", lazy.group["scratchpad"].dropdown_toggle("omni")),
         Key([mod], "period", Function.dropdown_kill_toggle("omni")),
         Key([mod], "semicolon", lazy.group["scratchpad"].dropdown_toggle("kate")),
    ]

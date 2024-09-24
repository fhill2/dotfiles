#!/usr/bin/python
from rofi import Rofi


entries = [
[ "i3_manual_set_mark_rofi [F]", "i3_manual_set_mark_rofi" ],
["i3_save_layout [F]", "i3_save_layout"],
["i3_restore_layout [F]", "i3_restore_layout"],
["restart process [F]", "i3_restart_process"],
["i3_new_layout_dev_term [F]", "i3_new_layout_dev_term"],
["i3_new_layout_alt_term [F]", "i3_new_layout_alt_term"],
["i3_new_layout_dev_browser [F]", "i3_new_layout_dev_browser"],
["i3_new_layout_alt_browser [F]", "i3_new_layout_alt_browser"],
["i3_new_layout_notes [F]", "i3_new_layout_notes"],
["rofi_power_menu", "rofi -show power-menu -modi power-menu:rofi_power_menu"],
["launch - sgsync", 'sway_toggle_terminal_dropdown_ff launch "sgsync.py"'],
# ["partial screenshot - copy to clipboard", 'grim -g "$(slurp)" - | wl-copy'],
        # ["partial screenshot - save to ~/Pictures - fp as date", 'grim -g "$(slurp)" $(xdg-user-dir PICTURES)/$(date "+%Y-%m-%d_%H:%M:%S").png'],
        # ["whole screenshot - current monitor - copy to clipboard", "grim -o $(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name') - | wl-copy"],
        # ["whole screenshot - current monitor - save to ~/Pictures - fp as date", "grim -o $(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name') $(xdg-user-dir PICTURES)/$(date '+%Y-%m-%d_%H:%M:%S').png"],
]

options = list(map(lambda x: x[0], entries))

rofi = Rofi()
# key = key the user pressed - enter, spacebar
index, key = rofi.select("Global Menu", options)

if index == -1:
    exit(1)
else:
    print(entries[index][1])
    exit(0)



# s=subprocess.check_output(["echo", "Hello World!"])

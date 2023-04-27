#!/usr/bin/python
import sys

entries = [
        [ "power menu", "sway_power_menu"],
        ["mark - manually set mark", "source sway_wrapper && sway_manual_set_mark_rofi"],
        ["layout - new dev layout", "sway_new_dev_layout"],
        ["print current active window ID", "source sway_wrapper && sway_notify_curr_id"],
        ["restart_process", "source sway_wrapper && sway_restart_process"],
        ["launch - sgsync", 'sway_toggle_terminal_dropdown_ff launch "sgsync.py"'],


        # https://git.sr.ht/~emersion/grim/
        ["partial screenshot - copy to clipboard", 'grim -g "$(slurp)" - | wl-copy'],
        ["partial screenshot - save to ~/Pictures - fp as date", 'grim -g "$(slurp)" $(xdg-user-dir PICTURES)/$(date "+%Y-%m-%d_%H:%M:%S").png'],
        ["whole screenshot - current monitor - copy to clipboard", "grim -o $(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name') - | wl-copy"],
        ["whole screenshot - current monitor - save to ~/Pictures - fp as date", "grim -o $(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name') $(xdg-user-dir PICTURES)/$(date '+%Y-%m-%d_%H:%M:%S').png"],
        ]

if __name__ == "__main__":
    # print(len(sys.argv))
    if len(sys.argv) == 1:
        for entry in entries:
            print(entry[0])

    if len(sys.argv) == 2:
        for entry in entries:
            if sys.argv[1] == entry[0]:
                print(entry[1])
                exit()

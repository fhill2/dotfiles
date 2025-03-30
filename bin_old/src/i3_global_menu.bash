#!/usr/bin/env bash
source i3_wrapper

texts=(
"i3_manual_set_mark_rofi [F]"
"i3_save_layout [F]"
"i3_restore_layout [F]"
"restart process [F]"
"i3_new_layout_dev_term [F]"
"i3_new_layout_alt_term [F]"
"i3_new_layout_dev_browser [F]"
"i3_new_layout_alt_browser [F]"
"i3_new_layout_notes [F]"
"rofi_power_menu"
"launch - sgsync"
)



actions=(
"i3_manual_set_mark_rofi"
"i3_save_layout"
"i3_restore_layout"
"i3_restart_process"
"i3_new_layout_dev_term"
"i3_new_layout_alt_term"
"i3_new_layout_dev_browser"
"i3_new_layout_alt_browser"
"i3_new_layout_notes"
"rofi -show power-menu -modi power-menu:rofi_power_menu"
'sway_toggle_terminal_dropdown_ff launch "sgsync.py"'
)

# construct all texts
ROFI_INPUT=""
for i in "${texts[@]}"
do
  ROFI_INPUT=$ROFI_INPUT"$i\n"
done

index=$(echo -e "$ROFI_INPUT" | rofi -dmenu -format 'i')
${actions[index]}

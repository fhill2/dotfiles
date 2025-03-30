#!/bin/sh

### THIS IS NOT WORKING
echo " ========== $(date) - i3_preview_startup.sh =========="


pkill mpv; sleep 0.1
# you can change x11 class name of mpv window - could you assign and class name change instead of marks
# https://mpv.io/manual/master/#window

# --keep-open=always -> otherwise when previewing images, mpv closes automatically
# --force-window=immediate -> force mpv to spawn a window and not stay in CLI mode
# - -> read from stdin - paired with --force-window to force the window to open
# --geometry -> experimenting with mpv to lock aspect ratio when resizing
MPV_ID="$(i3_open_wait_window.py 'mpv --autofit-larger=50%x50% --keep-open=always --force-window=immediate -' | jq -r '.window')"
sleep 1
swaymsg "[con_id=$MPV_ID] mark preview_mpv; floating enable; move container to workspace number 7"
swaymsg "[con_id=$MPV_ID] resize set width 50 ppt height 50 ppt"
swaymsg "[con_id=$MPV_ID] move to position 0 0"
#
# # setup zathura
ZATHURA_ID="$(i3_open_wait_window.py 'zathura' | jq -r '.window')"
sleep 1
swaymsg "[con_id=$ZATHURA_ID] mark preview_zathura; floating enable; move container to workspace number 7"
swaymsg "[con_id=$ZATHURA_ID] resize set width 30 ppt height 80 ppt"

# # setup kitty
KITTY_ID="$(i3_open_wait_window.py 'kitty sh -c i3_preview_terminal.sh' | jq -r '.window')"
sleep 1
swaymsg "[con_id=$KITTY_ID] mark preview_kitty; floating enable; move container to workspace number 7; resize set width 30 ppt height 80 ppt"
# swaymsg "[con_id=$KITTY_ID] resize set width 30 ppt height 80 ppt"
#
#

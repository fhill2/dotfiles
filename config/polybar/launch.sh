#!/bin/bash

# https://wiki.archlinux.org/title/Polybar#Running_with_a_window_manager
# Terminate already running bar instances
killall -q polybar
# If all your bars have ipc enabled, you can also use
# polybar-msg cmd quit

# Launch Polybar, using default config location ~/.config/polybar/config.ini
polybar example 2>&1 | tee -a $HOME/logs/polybar.log & disown

# echo "Polybar launched..."

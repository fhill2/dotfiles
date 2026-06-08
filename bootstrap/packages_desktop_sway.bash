#!/bin/bash

# Install this for developing on linux ubuntu
# Using Sway

declare -a SWAY_CMD=()

SWAY_CMD+=(
    ###### WAYLAND ONLY APPS #####
    #
    sway
    # configuring multimonitors on wayland
    wdisplays
    # App Launcher
    wofi
    # wayland only portal used for screencast/shots
    xdg-desktop-portal-wlr
    ##### END WAYLAND ONLY #####
)

sudo apt install -y "${SWAY_CMD[@]}"

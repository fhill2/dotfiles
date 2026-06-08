#!/bin/bash

# 1. Core Desktop: Install these with standard recommendations
# These are essential for the system to actually be functional.
CORE_CMD=(
    gdm3
    gnome-shell
    gnome-control-center
    nautilus
)
sudo apt install -y "${CORE_CMD[@]}"

# 2. Utilities: Install these with --no-install-recommends
# These are safe to prune of 'suggested' bloat.
UTIL_CMD=(
    gnome-sushi
    xdg-desktop-portal-gnome
    xdg-desktop-portal-gtk
)
sudo apt install -y --no-install-recommends "${UTIL_CMD[@]}"

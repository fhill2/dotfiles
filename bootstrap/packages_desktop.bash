#!/bin/bash

# Install this if developing on linux ubuntu
# and Either using Gnome w Wayland or Sway

# Initialize an empty array for the command arguments
declare -a CMD=()

# Build the command arguments array
CMD+=(
    # packages I need only on f-desktop

    # to install vesktop
    flatpak

    # core_desktop
    syncthing

    obs-studio
    # for the debian/bin/start_screenshare script
    wl-mirror

    # Building wayland apps from source
    meson
    libcairo2-dev
    ninja-build
    # libinput C dep
    libinput-dev
    # pango C dep
    libpango1.0-dev
    # wayland-client C dep
    librust-wayland-client-dev
    wayland-protocols
    libxkbcommon-dev

    # debian does not install audio configuration support by default
    pipewire-pulse
    wireplumber
    qpwgraph
    pavucontrol
    # possibly ubuntu only package
    # installs pactl to configure pipewire pulse
    pipewire-utils

    # required to use qmk compile on debian
    python3-appdirs

    spacefm
    # spacefm dep
    udevil

    # to validate .desktop files
    desktop-file-utils

    rsync

    # neovim clipboard copy and paste for wayland
    wl-clipboard
    # take screenshots on wayland
    grim
    # wayland blue light filter (X11 redshift alternative)
    gammastep
    # Open X11 Apps in wayland
    xwayland

    # useful debian utilities
    devscripts

    # shell script test framework
    bats
    bats-file
    bats-support
    bats-assert

    just
    vlc

    # system node for installing neovim LSPs:
    nodejs
    npm

    # pytower
    supervisor
)

sudo apt install -y "${CMD[@]}"

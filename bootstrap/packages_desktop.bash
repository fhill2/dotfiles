#!/bin/bash

# Initialize an empty array for the command arguments
declare -a CMD=()

# Build the command arguments array
# Note: Comments are on their own lines, preceding the argument they describe.
# This syntax is robust and ensures comments are ignored by Bash during execution.
# These packages exist on debian, but do not exist on ubuntu:
# qmk
# fuse # dependency of AppImages
CMD+=(
	# packages I need only on f-desktop

	# to install vesktop
	flatpak

	# core_desktop
	syncthing

	# screen recording setup
	# TODO: install the VAAPI hardware encoder
	# xdg-desktop-portal (commented out as it's not a package to install here, or is part of desktop-portal-wlr)
	xdg-desktop-portal-wlr
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

	# wayland - desktop utility apps
	# configuring multimonitors on wayland
	wdisplays
	# take screenshots on wayland
	grim
	# wayland blue light filter (X11 redshift alternative)
	gammastep
	# App Launcher
	wofi
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

	# pytower
	supervisor

	####### DEPRECATED #######
	# The packages below are marked as DEPRECATED in the source
	# and will not be included in the installation list.
	# docker.io
	# docker-cli
	# sudo /usr/sbin/usermod -aG docker $USER
)

# Now execute the command
# sudo is placed outside the array as it's the command prefix.
# apt install are the fixed command words.
# "${CMD[@]}" expands all elements of the CMD array as separate arguments.
sudo apt install -y "${CMD[@]}"

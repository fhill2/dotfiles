#!/bin/bash

# SCRIPT_DIR=$(dirname "$0")
#
# output=()
#
# # Read the file line by line
# while IFS= read -r line; do
# 	# Check for empty lines or lines with only whitespace
# 	if [[ -z "$line" || "$line" =~ ^[[:space:]]*$ ]]; then
# 		continue
# 	fi
# 	# Check if the line starts with a '#'
# 	if [[ ! "$line" =~ ^# ]]; then
# 		# If not a comment, append the line to the array
# 		output+=("$line")
# 	fi
# done <"$SCRIPT_DIR/packages.txt"
#
# # If the package is already installed but a newer version is available in the repositories: apt-get will update the package to the newer version.
# for line in "${output[@]}"; do
# 	sudo apt-get install -y "$line"
# done

sudo apt update
# awk -f update_packages.awk packages.ini | sudo xargs apt install -y

# Initialize an empty array for the command arguments
declare -a CMD=()

# Build the command arguments array
# Note: Comments are on their own lines, preceding the argument they describe.
# This syntax is robust and ensures comments are ignored by Bash during execution.
CMD+=(
	# essential packages:
	# required for apt custom repos
	gnupg
	curl
	wget
	zsh
	git
	# elogind or seatd (seat management daemon) is needed for sway to launch
	seatd
	sway
	kitty
	zsh-antigen
	trash-cli
	jq
	man
	openssh-server
	nmap
	cmake
	fd-find
	ripgrep
	fzf
	# check file folder sizes to clear space
	ncdu
	isc-dhcp-client
	firefox-esr
	wmctrl
	# neovim clipboard copy and paste for wayland
	wl-clipboard
	# display visual input for configuring keymapping software
	wshowkeys
	rustc
	tmux

	# system python (install system python as some python packages aren't available on apt):
	python3
	python3-pip
	direnv

	# system node for installing neovim LSPs:
	nodejs
	npm

	# pytower deps:
	python3-poetry
	clang

	# SMB tools:
	# query smb shares
	# mount smb share
	smbclient
	cifs-utils

	# pytower runtime:
	# py-spy dep (installed using cargo)
	# libunwind-devel

	# system time (enables ntp, otherwise system clock goes out of sync and web browsers start producing errors):
	systemd-timesyncd
)

# Now execute the command
# sudo is placed outside the array as it's the command prefix.
# apt install are the fixed command words.
# "${CMD[@]}" expands all elements of the CMD array as separate arguments.
sudo apt install -y "${CMD[@]}"

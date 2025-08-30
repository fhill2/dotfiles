#!/bin/bash

sudo apt update

# Initialize an empty array for the command arguments
declare -a CMD=()

# These packages do not exist on Ubuntu, but do exist on debian:
# firefox-esr
# wshowkeys

CMD+=(
	# essential packages:
	# required for apt custom repos
	rustup
	rustc

	gnupg
	curl
	wget
	zsh
	git
	# elogind or seatd (seat management daemon) is needed for sway to launch
	seatd
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

	tmux

	# system python (install system python as some python packages aren't available on apt):
	python3
	python3-pip

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

	# ubuntu install - pstree
	psmisc
)

# "${CMD[@]}" expands all elements of the CMD array as separate arguments.
sudo apt install -y "${CMD[@]}"

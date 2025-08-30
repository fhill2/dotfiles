#!/bin/bash
sudo apt update
declare -a CMD=()

CMD+=(
	xorg
	i3
	##### X11 ONLY APPS #####
	wmctrl # X11 app
)
sudo apt install -y "${CMD[@]}"

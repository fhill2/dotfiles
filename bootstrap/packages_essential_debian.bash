#!/bin/bash

sudo apt update
declare -a CMD=()

# These packages install on Debian Only
# They are not available on Ubuntu
CMD+=(
	firefox-esr
	man-db
)

# "${CMD[@]}" expands all elements of the CMD array as separate arguments.
sudo apt install -y "${CMD[@]}"

#!/bin/bash

sudo apt update
declare -a CMD=()

# These packages install on Debian and Ubuntu (without any custom apt repos)
CMD+=(

	# DO NOT install rustup using apt
	# rustup self update is disabled
	# Instead install manually using their shell method
	rustup
)

# "${CMD[@]}" expands all elements of the CMD array as separate arguments.
sudo apt install -y "${CMD[@]}"

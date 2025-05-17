#!/bin/bash

SCRIPT_DIR=$(dirname "$0")

output=()

# Read the file line by line
while IFS= read -r line; do
	# Check for empty lines or lines with only whitespace
	if [[ -z "$line" || "$line" =~ ^[[:space:]]*$ ]]; then
		continue
	fi
	# Check if the line starts with a '#'
	if [[ ! "$line" =~ ^# ]]; then
		# If not a comment, append the line to the array
		output+=("$line")
	fi
done <"$SCRIPT_DIR/packages.txt"

# Print the array (optional)
for line in "${output[@]}"; do
	sudo apt-get install -y "$line"
done

#!/usr/bin/env bash

# _symlinks_current_dir="${BASH_SOURCE%/*}"

# function dotfiles_location() {
#   echo $(cd $_symlinks_current_dir/../.. && pwd)
# }

function dotfiles_location() {
  echo "$HOME/dot"
}

function _symlink() {
    # Get the name of the symlink
source=$1
destination=$2

  # if file exists
  if [ -e "$destination" ]; then
  
# Get the path to the original file
original_file=$(readlink -f "$symlink")

# Check if the original file exists
if [ ! -f "$original_file" ]; then
  # if the original file does not exist...

  # Prompt the user if they want to delete the symlink
  echo "$destination original file: $original_file - does not exist. Do you want to delete $destination?"
  read -n 1 -r -p "(y/N) " response

  # Delete the symlink if the user said yes
  if [[ $response =~ [Yy] ]]; then
    rm "$destination"
  fi
fi

  else
    echo "Symlinking $source -> $destination"
    mkdir -p "$(dirname "$destination")"


    # Try to create the symlink
  if ln -s "$source" "$destination"; then
    return 0
  fi

    # If the symlink failed, try again as sudo
  echo "Symlink failed - Sudo Symlinking $source -> $destination?"
  read -n 1 -r -p "(y/N): " response
  echo ""
  if [[ $response =~ [Yy] ]]; then
  sudo mkdir -p "$(dirname "$destination")"
  sudo ln -s "$source" "$destination"
  fi
  fi
  
}

function symlink_dotfile() {
  # symlink_dotfile - always relative to the dotfiles location
  _symlink "$(dotfiles_location)/$1" "$2"
}

function symlink_relative_dotfile() {
  _symlink "$(pwd)/$1" "$2"
}

function symlink_absolute_dotfile() {
  # always pass in absolute source and target
  _symlink "$1" "$2"
}

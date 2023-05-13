#!/usr/bin/env bash

# _symlinks_current_dir="${BASH_SOURCE%/*}"

# function dotfiles_location() {
#   echo $(cd $_symlinks_current_dir/../.. && pwd)
# }

function dotfiles_location() {
  echo "$HOME/dot"
}

function symlink_dotfile() {
  local file=$1
  local destination=$2
  local full_file_path="$(dotfiles_location)/$file"

  if [ ! -e "$destination" ]; then
    echo "Symlinking $full_file_path -> $destination"
    mkdir -p "$(dirname "$destination")"
    ln -s "$full_file_path" "$destination"
  fi
}

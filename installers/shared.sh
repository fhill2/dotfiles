#!/usr/bin/env bash

# shared scripts = shared with zsh and the bootstrap installer
# all 
# moved the installer scripts to the zsh folder in dotfiles
# because dot/zsh symlinks to ~/.zsh, and all zsh config uses ~/.zsh paths
# this is so I can share aliases/functions like symlink_dotfiles for use interactively, as well as on the bootstrap installer.

#shared_dir="${BASH_SOURCE%/*}/shared"
shared_dir="./zsh/installers"

if [[ "$SOURCED_SHARED_DOTFILES" != "yes" ]]; then
  source "$shared_dir/config.sh"
  source "$shared_dir/os-detection.sh"
  source "$shared_dir/aptitude.sh"
  source "$shared_dir/homebrew.sh"
  source "$shared_dir/packages.sh"
  source "$shared_dir/symlinks.sh"
  source "$shared_dir/stdout.sh"
  source "$shared_dir/require.sh"

  SOURCED_SHARED_DOTFILES="yes"
fi
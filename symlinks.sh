#!/usr/bin/env sh

# TODO:
# setup a better way to symlink scripts into a directory on PATH
# bin files
# TODO:
# take out auto running as sudo in the _symlink script
# and add sudo to each line that needs it
#
# Systems Managed:
# OSX: osx-lap, osx-studio
# f-desktop, f-server, f-twickenham <-- debian
# ai <-- opensuse

HOST="$(hostname)"

PSDIR=$(dirname "$0")                               # --> script dir's parent
root="$(git -C "$PSDIR" rev-parse --show-toplevel)" # find git root from PSDIR
_symlink="$root/bin/src/_symlink"

os=$(uname -s)

mkdir -p $HOME/apps
mkdir -p $HOME/git
mkdir -p $HOME/projects
mkdir -p $HOME/Desktop
mkdir -p $HOME/.config
mkdir -p $HOME/.claude

# this does not exist on a fresh debian install
# mkdir -p $HOME/.local

mkdir -p ~/.config/bat

# in rare cases, ~/.local/bin is used as a copy destination for manually compiled apps
# Example, some haskell apps I've used compile and copy the binary to this location
$_symlink $root/bin/src ~/.local/bin

$_symlink $root/config/nvim ~/.config/nvim
$_symlink $root/config/git/gitconfig ~/.gitconfig
# $_symlink $root/config/git/gitignore ~/.gitignore
$_symlink $root/config/broot ~/.config/broot
$_symlink $root/config/xplr ~/.config/xplr
$_symlink $root/config/tmux ~/.config/tmux
$_symlink $root/config/starship.toml ~/.config/starship.toml
$_symlink $root/config/bat/config ~/.config/bat/config

$_symlink $root/config/claude/settings.json ~/.claude/settings.json
$_symlink $root/config/claude/CLAUDE.md ~/.claude/CLAUDE.md

if [ "$os" = "Darwin" ]; then
  $_symlink $root/config/opencode/opencode_osx.json ~/.config/opencode/opencode.json
else
  $_symlink $root/config/opencode/opencode_linux.json ~/.config/opencode/opencode.json
fi
$_symlink $root/config/opencode/tui.json ~/.config/opencode/tui.json
$_symlink $root/config/worktrunk/config.toml ~/.config/worktrunk/config.toml

if [ "$os" = "Darwin" ]; then
  $_symlink $root/config/lazygit/config.yml "$HOME/Library/Application\ Support/lazygit/config.yml"
else
  $_symlink $root/config/lazygit/config.yml ~/.config/lazygit/config.yml
fi

$_symlink $root/config/shell/bashrc ~/.bashrc
$_symlink $root/config/shell/zshrc ~/.zshrc
$_symlink $root/config/shell/zprofile ~/.zprofile
$_symlink $root/config/profile ~/.profile

$_symlink $root/config/kitty ~/.config/kitty
$_symlink $root/config/alacritty ~/.config/alacritty

if [ "$HOST" = "f-studio" ]; then

  ##### PHASE PLANT #####
  # PhasePlant Factory presets are managed at /Library/Application Support/Kilohearts/presets - They do not need to be symlinked
  # Symlink PhasePlant Splice presets to PhasePlant User Preset location
  $_symlink "/Users/s1/Splice/presets/Phase Plant" "/Users/s1/Library/Audio/Presets/Kilohearts/Phase Plant/User Presets/Splice"
  # Symlink my Phaseplant Presets to PhasePlant User Preset location
  $_symlink "/Users/Shared/prod_shared/sample_libraries/phase_plant" "/Users/s1/Library/Audio/Presets/Kilohearts/Phase Plant/User Presets/User"

  $_symlink "/Users/Shared/prod_shared/sample_libraries/addictive_drums_2" "/Library/Application Support/XLN Audio/Addictive Drums 2"

  ##### VITAL #####
  # Vital Factory Content is not installed with the installer. It's provided as a separate download on the website.
  # So Factory + User Presets can be symlinked from sample_libraries into the Vital Preset Location

  # Vital Preset Location: /Users/s1/Documents/Vital
  # Vital Preset Structure:
  # /Users/s1/Documents/Vital:
  # /Splice
  # /Factory_User

  # Vital Factory & User Presets are inside sample_libraries - symlink these to Vital preset directory
  $_symlink "/Users/Shared/prod_shared/sample_libraries/vital/Vital User Presets" "/Users/s1/Music/Vital/Presets/User"
  # Symlink Vital Splice Presets to Vital Preset directory
  $_symlink "/Users/s1/Splice/presets/Vital" "/Users/s1/Music/Vital/Presets/Splice"

  ##### NEXUS #####
  # Nexus default library location:
  # /Library/Audio/Presets/ReFX/Nexus Content
  $_symlink "/Users/Shared/prod_f/SAMPLE_LIBRARIES/nexus/Nexus Library" "/Library/Audio/Presets/reFX/Nexus Library"
fi

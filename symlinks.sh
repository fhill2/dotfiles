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

# this does not exist on a fresh debian install
mkdir -p $HOME/.local

mkdir -p ~/.config/bat

# ~/.local/bin is the location for my personal scripts
# shell config files then add this location to the PATH
# ~/.local/bin is not on $PATH on OSX or Linux (OpenSUSE, Debian, Ubuntu)
# in rare cases, ~/.local/bin is used as a copy destination for manually compiled apps
# Example, some haskell apps I've used compile and copy the binary to this location
$_symlink $root/bin/src ~/.local/bin

if [ "$HOST" = "f-desktop" ]; then
	$_symlink $root/bin/src/start_screenshare ~/.local/bin/start_screenshare
	$_symlink $root/bin/src/stop_screenshare ~/.local/bin/stop_screenshare
fi

$_symlink $root/config/nvim ~/.config/nvim
$_symlink $root/config/git/gitconfig ~/.gitconfig
# $_symlink $root/config/git/gitignore ~/.gitignore
$_symlink $root/config/broot ~/.config/broot
$_symlink $root/config/xplr ~/.config/xplr
$_symlink $root/config/tmux ~/.config/tmux
$_symlink $root/config/starship.toml ~/.config/starship.toml
$_symlink $root/config/bat/config ~/.config/bat/config

if [ "$os" = "Darwin" ]; then
	$_symlink $root/config/lazygit/config.yml "$HOME/Library/Application\ Support/lazygit/config.yml"
else
	$_symlink $root/config/lazygit/config.yml ~/.config/lazygit/config.yml
	$_symlink $root/config/systemd/user ~/.config/systemd/user
	# modified desktop files
	$_symlink $root/config/desktop/obsidian-wayland.desktop ~/.local/share/applications/obsidian-wayland.desktop
	$_symlink $root/config/desktop/discord-wayland.desktop ~/.local/share/applications/discord-wayland.desktop
	$_symlink $root/config/desktop/ib-gateway-wayland.desktop ~/.local/share/applications/ib-gateway-wayland.desktop
	$_symlink $root/config/desktop/spacefm-wayland.desktop ~/.local/share/applications/spacefm-wayland.desktop
	$_symlink $root/config/desktop/arduino-wayland.desktop ~/.local/share/applications/arduino-wayland.desktop

fi

$_symlink $root/config/shell/bashrc ~/.bashrc
$_symlink $root/config/shell/zshrc ~/.zshrc
$_symlink $root/config/shell/zprofile ~/.zprofile
$_symlink $root/config/profile ~/.profile

$_symlink $root/config/sway ~/.config/sway
$_symlink $root/config/kitty ~/.config/kitty
$_symlink $root/config/alacritty ~/.config/alacritty

$_symlink $root/config/lnav/pytower ~/.config/lnav/configs/pytower

# kanata should only install on f-server for now
if [ "$HOST" = "f-server" ]; then
	# https://github.com/jtroo/kanata/blob/main/docs/setup-linux.md
	$_symlink "$root/config/kanata" ~/.config/kanata
	$_symlink "$root/config/init.d/kanata" /etc/init.d/kanata
	$_symlink "$root/config/kanata/99-input.rules" /etc/udev/rules.d/99-input.rules
fi

if [ -f "$root/config/interfaces_$HOST" ]; then
	$_symlink "$root/config/interfaces_$HOST" /etc/network/interfaces
fi

if [ "$HOST" = "f-desktop" ]; then
	# Note: qmk setup command should be run before this
	$_symlink "$root/config/qmk/fhill2_keymap" ~/qmk_firmware/keyboards/gmmk/pro/rev1/ansi/keymaps/fhill2
	# QMK Keyboard - Prevent Permission Denied on qmk console
	$_symlink "$root/config/qmk/udev/92-viia.rules" /etc/udev/rules.d/92-viia.rules
fi

# Install on servers only (servers use X11)
if [ "$HOST" = "f-server" ] || [ "$HOST" = "gprot" ]; then
	$_symlink "$root/config/xinitrc" ~/.xinitrc
	$_symlink "$root/config/xprofile" ~/.xprofile
	$_symlink "$root/config/i3/config" ~/.config/i3/config
fi

# OSX only below here

# if [ "$HOST" = "Darwin" ]; then
# 	$_symlink "$HOME/data/Alfred" "$HOME/Library/Application Support/Alfred"
# 	$_symlink $root/config/skhd ~/.config/skhd

# 	# NOTE: only karabiner full config folder can be symlinked
# 	# individual karabiner.json cannot be symlinked, as karabiner overwrites the karabiner.json whern adding new complex modifications, destroying the symlink
# 	# NOTE: everytime a complex modification is edited inside assets/complex_modifications, the rule needs to be deleted and re-enabled in the GUI (does not need a restart)
# 	$_symlink $root/osx/config/karabiner ~/.config/karabiner

# 	# TODO: symlink all within launchd
# 	# $_symlink "$HOME/dot/config/launchd" "$HOME/Library/LaunchAgents"

# 	$_symlink $root/config/vlc ~/.config/vlc

# 	# VSCODE_CONFIG_DIR="$HOME/Library/Application Support/Code/User"
# 	# mkdir -p "$VSCODE_CONFIG_DIR"
# 	# symlink_dotfile config/vscode/keybindings.json "$VSCODE_CONFIG_DIR/keybindings.json"
# 	# symlink_dotfile config/vscode/settings.json "$VSCODE_CONFIG_DIR/settings.json"

# 	$_symlink $root/osx/config/yabai ~/.config/yabai

# 	echo "Open karabiner, skhd, yabai manually and accept Security & Privacy"
# fi

if [ "$HOST" = "fprod" ]; then
  ##### PHASE PLANT #####
  # PhasePlant Factory presets are managed at /Library/Application Support/Kilohearts/presets - They do not need to be symlinked
  # Symlink PhasePlant Splice presets to PhasePlant User Preset location
  $_symlink "/Users/s1/Splice/presets/Phase Plant" "/Users/s1/Library/Audio/Presets/Kilohearts/Phase Plant/User Presets/Splice"
  # Symlink my Phaseplant Presets to PhasePlant User Preset location
  $_symlink "/Users/Shared/prod_shared/sample_libraries/phase_plant" "/Users/s1/Library/Audio/Presets/Kilohearts/Phase Plant/User Presets/User"

  ##### VITAL #####
  # Vital Factory Content is not installed with the installer. It's provided as a separate download on the website.
  # So Factory + User Presets can be symlinked from sample_libraries into the Vital Preset Location
 

  # Vital Preset Location: /Users/s1/Documents/Vital
  # Vital Preset Structure:
  # /Users/s1/Documents/Vital:
  # /Splice
  # /Factory_User

  # Vital Factory & User Presets are inside sample_libraries - symlink these to Vital preset directory
  $_symlink "/Users/Shared/prod_shared/sample_libraries/vital/Vital" "/Users/s1/Documents/Vital/Factory_User"
  # Symlink Vital Splice Presets to Vital Preset directory
  $_symlink "/Users/s1/Splice/presets/Vital" "/Users/s1/Documents/Vital/Splice"
fi


# deprecated
# f-server postgres needs to override the system installed systemd service file
# to modify the PG_DATA path to the zfs dataset
# if [ "$HOST" = "f-server" ]; then
# $_symlink "$root/debian/config/systemd/postgresql_f-server.service" /usr/lib/systemd/system/postgresql.service
# fi
# Note: barman does not work with symlinks
# It does work with hard links (ln instead of ln -s)
# sudo ln "$root/debian/config/barman/basebackups.cron" /etc/cron.d/basebackups
# sudo ln "$root/debian/config/barman/f-server.conf" /etc/barman.d/f-server.conf

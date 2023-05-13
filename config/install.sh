#!/usr/bin/env bash

# this script needs to be located at the root of the dotfiles repository
# so I can use the dotbot symlink syntax without specifying the source (relative source to dotfiles dir)
# https://github.com/anishathalye/dotfiles/blob/master/install

set -e
BASEDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"



source "${BASH_SOURCE%/*}/install/util.sh"


function install_syms() {

    is_linux && "$HOME/.local/bin/dotbot" -v -d "${BASEDIR}" \
    -c "install/dotbot/sym.yaml" \
    -p ./install/dotbot/sudo.py



}

function install_pkgs() {
    is_linux && python install/install_pkgs.py
    is_mac 
}


case $1 in
  # if all is passed as first argument, install all parts of config
  "all")
  install_syms
  install_pkgs
    ;;
  "pkg")
  install_pkgs
  ;;
"sym")
    install_syms
    ;;
  *)
  ;;
esac


# UNUSED BOOTSTRAP

# if no arguments are passed in, install syms only
# if [ $# = 0 ];then
#   chosen="sym"
# else
#   chosen="$1"
# fi


# if [ "$EUID" -ne 0 ]
# then echo "Please run as root"
#   exit
# fi

# if [ "$EUID" -ne 1000 ]
# then echo "Please run as f1 user"
#   exit
# fi

# this is better included in the arch-ext4 installer script as checking if this file exists on a user account without sudo access fails
# if 99_sudoers_file does not exist
# if [[ ! -e /etc/sudoers.d/99_sudo_include_file ]]; then
  # echo "sudoers ran"
  # echo "Defaults editor=/usr/bin/nvim" >> /etc/sudoers.d/99_sudo_include_file
  # echo "f1 ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/99_sudo_include_file
  # visudo -cf /etc/sudoers.d/99_sudo_include_file
# fi

# ~/.config/syncthing/config.xml
# change <address></address> to 0.0.0.0
# this allows connecting to show syncthing web gui over LAN
# cant sync this file as it contains device IDs
# and cba to script with aug or sed
# ```xml
# <gui enabled="true" tls="false" debugging="false">
# <address>0.0.0.0:8384</address>
# <apikey>Po7cHpbLHs7sjRuNRJkJXQG2gxstbuxC</apikey>
# <theme>default</theme>
# </gui>

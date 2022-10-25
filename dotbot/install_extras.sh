#!/usr/bin/env sh

# some programs need installing and then some extra post setup
# remember: yay --needed does not work correctly (does not detect if a package already exists)
# https://github.com/Jguer/yay/issues/1552

# if docker is not installed
if ! pacman -Qe docker > /dev/null 2>&1; then
  sudo pacman -S docker
  sudo usermod -aG docker f1
  sudo systemctl enable --now docker.service
  echo "docker requires restart / logout to start"
fi
if ! pacman -Qe ckb-next > /dev/null 2>&1; then
  yay -S ckb-next && sudo systemctl enable --now ckb-next
fi


if ! pacman -Qe fman > /dev/null 2>&1; then
  ./install_fman.sh
fi

# if file doesnt exist
[ ! -e "$HOME/dev/bin/iconlookup" ] && curl -L https://raw.githubusercontent.com/jarun/nnn/master/plugins/.iconlookup -o $HOME/dev/bin/iconlookup


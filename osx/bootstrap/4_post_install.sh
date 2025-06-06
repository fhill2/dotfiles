#!/usr/bin/bash
#
# Run after main homebrew install
brew_install rustup
rustup-init -y
source $HOME/.cargo/env

# need to restart terminal here, maybe source both zsh files again?
source ~/.zshrc
source ~/.zshenv

# brew services start postgresql@14

# yabai post install 2024

# Desktop install
brew services start syncthing
trash -rf "$HOME/Sync"
# xdg-open http://127.0.0.1:8384
#

# disable annoying "Blocked due to unidentified developer" popups
sudo spctl --master-disable

# Manual post install skhd

# This will probably change on the next install

# brew install skhd does not install the service by default
skhd --start-service
# this might be everything, if you get unidentified target error
# this is due to the app not being codesigned, and you have to codesign manually
#
# skhd can be codesigned
# https://github.com/koekeishiya/yabai/wiki/Installing-yabai-(from-HEAD)
# step 1: Keychain Access.app > Keychain Access > Certificate Assistance > click Create a Certificate - Certificate Assistant
# codesign -fs 'yabai-cert' $(brew --prefix yabai)/bin/yabai
# restart
# skhd --start-service

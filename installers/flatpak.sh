#!/usr/bin/env sh
# Install flatpak session configuration (Linux only)
# - environment.d makes flatpak app exports visible to systemd/GDM-launched
#   GNOME sessions (launch menu + PATH)
# - flathub remote so `flatpak install flathub <app>` works out of the box

set -e

if [ "$(uname -s)" != "Linux" ]; then
  echo "flatpak configuration is Linux only - nothing to do"
  exit 0
fi

mkdir -p "$HOME/.config/environment.d"

cp "$HOME/dot/config/systemd/environment.d/30-flatpak.conf" "$HOME/.config/environment.d/30-flatpak.conf"

# app repository - required before installing any app
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

echo "Done - log out and back in for the environment.d changes to apply"

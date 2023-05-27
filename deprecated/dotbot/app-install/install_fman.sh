if ! pacman -Qe fman > /dev/null 2>&1; then
# https://fman.io/download/thank-you?os=Linux&distribution=Arch%20Linux
pacman-key --keyserver hkp://keyserver.ubuntu.com:80 -r 9CFAF7EB
pacman-key --lsign-key 9CFAF7EB
echo -e '\n[fman]\nServer = https://fman.io/updates/arch' \
  >> /etc/pacman.conf

# https://github.com/fman-users/fman/issues/374

# fman does not separate out DATA_DIR and CONFIG_DIR
# so its  plugin system cannot be fully automated
# as the plugin system entails downloading the git repo into the CONFIG_DIR, it can easily be recreated




mkdir -p ~/.fman
ln -s ~/.fman ~/.config/fman/Plugins/Third-party
# all plugins listed under ctrl+shift+p come from  github search: topic:fman topic:plugin
git clone ~/.fman/
fi

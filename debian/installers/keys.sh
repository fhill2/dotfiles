# Install katana
# https://github.com/jtroo/kanata/blob/main/docs/setup-linux.md

# Install cargo packages
cargo install kanata

# This is not necessary on f-server install
sudo groupadd uinput
sudo usermod -aG input $USER
sudo usermod -aG uinput $USER
echo 'KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"' | sudo tee /etc/udev/rules.d/99-input.rules
sudo udevadm control --reload-rules && sudo udevadm trigger
sudo modprobe uinput
systemctl --user daemon-reload
systemctl --user enable kanata.service
systemctl --user start kanata.service
systemctl --user status kanata.service
# sudo chmod +x /etc/init.d/kanata # script must be executable
sudo rc-service kanata start
rc-status                         # check that kanata isn't listed as [ crashed ]
sudo rc-update add kanata default # start the service automatically at boot

# Restart is necessary, otherwise systemctl status kanata.service shows:
# Sep 19 20:23:14 f-server sh[268967]: 2024-09-19T20:23:14.654092487+01:00 [ERROR] Failed to open the output uinput device. Make sure you've added the user executing kanata to the `uinput` group

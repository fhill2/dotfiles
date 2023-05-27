# https://wiki.archlinux.org/title/Samba
sudo pacman -S --needed samba
# ensure dotfiles are symlinked here, as starting smb.service without symlinking /etc/samba/smb.conf will not start smb.service
sudo systemctl enable --now smb.service
# sudo systemctl start smb.service

# sudo pacman -S avahi
# sudo systemctl enable --now avahi-daemon.service
# If avahi-daemon.service is not running, the server will still be accessible, just not discoverable, i.e. it will not show up in file managers, but you can still connect to the server directly by IP or domain. 

# adds a user to smb server
sudo smbpasswd -a f1

# smb server does not use the same passwords as local user accounts

# at this point - connections from other devices on the network will connect to arch lap
# such as smb_connect_gypsy.sh

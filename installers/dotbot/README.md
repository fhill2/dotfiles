2023 New Arch Linux Install:
# Install Arch and Boot it
boot arch installer usb
curl -s gist-url -o arch-installer && chmod +x arch-installer
run installer/arch-install-ext4 (no longer using btrfs)


# Copy 
- remember to mount syncthing smb share as username=syncthing otherwise files are not visible
su root
sudo mount -vvvv -t cifs //192.168.0.100/syncthing /mnt -o username=syncthing,password=.

# Install apps - setup and config
./install all -> install syms with dotbot, this is necessary for package installer script to work (npm global user packages)
./install_pacman.py -> 
./dotbot/app-install/install_all.sh (syncthing, openssh keys)
set up syncthing to sync folders


# old: mounting with nfs:
mkdir /mnt/nas && sudo mount -t nfs4 192.168.0.100:/mnt/tank/syncthing /mnt/nas

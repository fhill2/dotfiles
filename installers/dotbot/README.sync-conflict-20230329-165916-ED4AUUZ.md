2023 New Arch Linux Install:
boot arch installer usb
curl -s gist-url -o arch-installer && chmod +x arch-installer
run installer/arch-install-ext4 (no longer using btrfs)

sudo mkdir /mnt/nas && sudo mount -t nfs 192.168.0.100:/mnt/tank/syncthingData /mnt/nas

copy over dev data and dot folders
run bootstrap.sh in dot/dotbot, install all with dotbot, enable syncthing to sync shared folders



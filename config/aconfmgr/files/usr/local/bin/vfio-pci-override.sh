#!/bin/sh
# https://wiki.archlinux.org/title/PCI_passthrough_via_OVMF#Script_variants
# symlink to /usr/local/bin/vfio-pci-verride.sh

# bind vfio-pci to all GPUs apart from the boot GPU
# for i in /sys/bus/pci/devices/*/boot_vga; do
#   if [ $(cat "$i") -eq 0 ]; then
#     GPU="${i%/boot_vga}"
#     AUDIO="$(echo "$GPU" | sed -e "s/0$/1/")"
#     USB="$(echo "$GPU" | sed -e "s/0$/2/")"
#     echo "vfio-pci" > "$GPU/driver_override"
#     if [ -d "$AUDIO" ]; then
#       echo "vfio-pci" > "$AUDIO/driver_override"
#     fi
#     if [ -d "$USB" ]; then
#       echo "vfio-pci" > "$USB/driver_override"
#     fi
#   fi
# done


# manually specify additional PCI devices to passthrough
# 23 = GPU
# 4c = UAD Card
# 48 = usb slot
DEVS="0000:23:00.0 0000:23:00.1"
#0000:48:00.0 0000:48:00.1 0000:48:00.3 0000:4d:00.

if [ ! -z "$(ls -A /sys/class/iommu)" ]; then
  for DEV in $DEVS; do
    echo "vfio-pci" > /sys/bus/pci/devices/$DEV/driver_override
  done
fi

modprobe -i vfio-pci


if [[ "$HOST" == "arch-desk" ]]
then
AddPackage iptables-nft # Linux kernel packet control tool (using nft interface)
AddPackage qemu # A generic and open source machine emulator and virtualizer
AddPackage virt-viewer # A lightweight interface for interacting with the graphical display of virtualized guest OS.
AddPackage dnsmasq # Lightweight, easy to configure DNS forwarder and DHCP server
AddPackage bridge-utils # Utilities for configuring the Linux ethernet bridge
AddPackage libguestfs # Access and modify virtual machine disk images
AddPackage vagrant # Build and distribute virtualized development environments
AddPackage ansible # Official assortment of Ansible collections
AddPackage packer # tool for creating identical machine images for multiple platforms from a single source configuration
AddPackage cockpit # A systemd web based user interface for Linux servers
AddPackage cockpit-machines # Cockpit UI for virtual machines
AddPackage nvme-cli # NVM-Express user space tooling for Linux
AddPackage edk2-ovmf # Firmware for Virtual Machines (x86_64, i686)
AddPackage cpupower # Linux kernel tool to examine and tune power saving related features of your processor
AddPackage cpupower-gui-git # A GUI utility to set CPU frequency limits
AddPackage driverctl # Device driver control utility
AddPackage libvirt # API for controlling virtualization engines (openvz,kvm,qemu,virtualbox,xen,etc)
fi


# Add backports to apt repos
# to install openzfs
echo "deb http://deb.debian.org/debian bookworm-backports main contrib" >/etc/apt/sources.list.d/debian-12-backports.list
sudo apt update
sudo apt install dpkg-dev linux-headers-amd64 linux-image-amd64
sudo apt install zfs-dkms zfsutils-linux

sudo apt install zfs-dkms/bookworm-backports

https://www.cyberciti.biz/faq/installing-zfs-on-debian-12-bookworm-linux-apt-get/
https://packages.debian.org/bookworm/zfs-dkms
https://github.com/openzfs/zfs/issues/15299
https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1077835
https://www.debian.org/releases/testing/release-notes/upgrading.en.html#installing-a-kernel-metapackage

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

# Before Installation:
# Ensure /usr/bin/pg_receivewal --version in the barman docker container
# and the postgres cluster
# have the same major version, e.g 15
#
zpool create tank mirror nvme0n1 nvme2n1 -f
# Create the postgres dataset
zfs create tank/postgres
# all zfs shares are mounted on the boot os at /tank
zfs set recordsize=8K tank/postgres
zfs set atime=off tank/postgres

# After this command is run and the data_directory is moved to /tank/postgres
# debian postgres still uses the pg_hba.conf config in /etc/postgresql/15/main/pg_hba.conf
# same for postgresql.conf
sudo -u postgres /usr/lib/postgresql/15/bin/initdb -D /tank/postgres
# zfs shares are owned by root when created
# post data directory cannot be owned by root
chown -R postgres:postgres /tank/postgres

### POSTGRES SETUP
# chown postgres:postgres /etc/postgresql/15/main/pg_hba.conf
# chown postgres:postgres /etc/postgresql/15/main/postgresql.conf
# Now manually change /etc/postgresql/17/main/postgresql.conf
# data_directory = '/tank/postgres'
# AND to accept all connections from LAN:
# listen_addresses = "*"
sudo systemctl restart postgresql.service
sudo systemctl restart postgresql@15-main
journalctl -xeu postgresql.service
# use this to debug the configuration and errors instantly bypassing systemd
sudo -u postgres pg_ctlcluster 15 main start

# Now login to psql and change postgres password
sudo -u postgres psql postgres
ALTER USER postgres WITH PASSWORD 'postgres'

# Barman setup
CREATE USER barman SUPERUSER
ALTER USER barman WITH PASSWORD 'barman'
# copy paste all pre req comamnds into psql
https://docs.pgbarman.org/release/3.12.1/user_guide/pre_requisites.html
CREATE USER streaming_barman WITH REPLICATION PASSWORD 'barman'

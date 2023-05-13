#!/bin/sh

sudo pacman -S --needed mariadb
yay -S --needed mycli # autocompletion and syntax highlighting
mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
sudo systemctl mariadb.service
mysql -u root -p

# atm I am not running mysql as a regular user

# https://dev.mysql.com/doc/mysql-security-excerpt/8.0/en/changing-mysql-user.html
# sudo chown -R f1 /var/lib/mysql

# create a new user
# https://wiki.archlinux.org/title/MariaDB
# CREATE USER 'f1'@'localhost' IDENTIFIED BY '.';
# GRANT ALL PRIVILEGES ON mydb.* TO 'f1'@'localhost';
# FLUSH PRIVILEGES;
# quit

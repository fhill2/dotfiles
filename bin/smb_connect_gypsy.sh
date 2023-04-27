#!/bin/sh

# Setup on OS X host (server)
# Sharing > File Sharing > On
# Options > Windows File Sharing (this might be necessary)

# File Sharing 

# smb server only accepts connections from an OS X user (harlow) if the user is logged in to their desktop

# this worked to list shares
# smbclient -U "harlows-air/harlow" -L 192.168.1.208 -W WORKGROUP

# su root for write access
sudo mount -t cifs //192.168.1.208/public-freddie /mnt -o username=harlow,password=$(pass show gypsy/lap-pass),nounix,sec=ntlmssp

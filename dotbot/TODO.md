# manual tweaks that I still need to automate:

# mounting smb shares with spacefm requires:

allowed_types = $KNOWN_FILESYSTEMS, file, cifs, nfs, curlftpfs, sshfs, davfs
in /etc/udevil/udevil.conf
(there is no home config AFAIK)

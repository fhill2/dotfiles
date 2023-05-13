IgnorePath '*'


# IgnorePath '/.snapshots/*'
# IgnorePath '/var/lib/docker/*'
# IgnorePath '/usr/lib/python3.*/site-packages'



# IgnorePath '/var/log/*'
# IgnorePath '/var/tmp/*'

# IgnorePath '/var/lib/pacman/local/*' # package metadata
# IgnorePath '/var/lib/pacman/sync/*.db' # repos
# IgnorePath '/var/lib/pacman/sync/*.db.sig' # repo sigs


# IgnorePath '/var/lib/pacman/sync/*.db.sig' # repo sigs

# IgnorePath '/usr/lib/node_modules/*' # repo sigs




# #https://github.com/CyberShadow/aconfmgr/issues/37#issuecomment-485582276
# # grugnog ignore list

# #https://superuser.com/questions/437330/how-do-you-add-a-certificate-authority-ca-to-ubuntu

# # Boot binaries

# IgnorePath '/boot/*' # freddie
# #IgnorePath '/boot/*.img'
# #IgnorePath '/boot/*/*.EFI'
# #IgnorePath '/boot/*/*.efi'
# #IgnorePath '/boot/vmlin*'
# # Certificate databases
# IgnorePath '/etc/ca-certificates/extracted/*'
# IgnorePath '/etc/ssl/certs/*'
# IgnorePath '/etc/pacman.d/gnupg/*'
# # Cache and generated files
# IgnorePath '/etc/*.cache'
# IgnorePath '/etc/*.gen'
# # Password files
# IgnorePath '/etc/*shadow*'
# IgnorePath '/usr/share/*'
# # Configuration database
# IgnorePath '/etc/dconf'
# # Mount files
# IgnorePath '*/.updated'
# IgnorePath '*/lost+found/*'
# # Opt packages (check that they don't include config)
# IgnorePath '/opt/*'
# # Binary libraries
# IgnorePath '/usr/lib/*'
# # Local binaries
# IgnorePath '/usr/local/include/*'
# IgnorePath '/usr/local/lib/*'
# IgnorePath '/usr/local/share/applications/mimeinfo.cache'
# # Var databases, logs, swap and temp files
# IgnorePath '/var/db/sudo'
# IgnorePath '/var/lib/*'
# IgnorePath '/var/log/*'
# IgnorePath '/var/swap*'
# IgnorePath '/var/tmp/*'

# IgnorePath '/etc/hostname' # this is auto generated with arch install script

# # I dont need printer job history files
# IgnorePath '/var/spool/cups/*'

# IgnorePath '*.pacnew'

# # temporary ignores
# IgnorePath '/usr/local/share/lua/*' # I expect this to be removed once I have created an edited luarocks PKGBUILD that auto installs 5.1
# IgnorePath '/usr/local/bin/luarocks*'
# IgnorePath '/usr/local/etc/luarocks/*'


# placeholder script to run all app-installers sh files in this folder
# keep each app install in a separate file so I can selectively choose what apps to install on a fresh install
# this is because, afaik, there is no way to run additional setup code after a pacman package installs with the dotbot-yay package.
# conditionals cannot be made to run if the package exists and attached to dotbot config, as the initial app setup will run everytime the dotbot config runs

# some programs need installing and then some extra post setup
# yay --needed does not work correctly (does not detect if a package already exists)

#
#
# wget_chmod() {
#   curl -L "$1" -o "$2" && chmod +x "$2"
# }
#
# # if file doesnt exist
# [ ! -e "$HOME/dev/bin/iconlookup" ] && wget_chmod https://raw.githubusercontent.com/jarun/nnn/master/plugins/.iconlookup "$HOME/dev/bin/iconlookup"
#
./install_ssh.sh
./install_docker.sh
./install_git.sh

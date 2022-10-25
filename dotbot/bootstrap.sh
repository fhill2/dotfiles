# this script needs to be only run once on a new arch install
# this assumes I have installed with the arch automated installer
# https://wiki.archlinux.org/title/Archinstall

su root

# archinstall script does not edit sudoers, and asks for password on each sudo invocation
# https://stackoverflow.com/a/54309791
# TODO: check for prescence of file first
echo "Defaults editor=/usr/bin/nvim" >> /etc/sudoers.d/99_sudo_include_file
echo "f1 ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/99_sudo_include_file
visudo -cf /etc/sudoers.d/99_sudo_include_file


# dotbot-yay plugin does not bootstrap by default
pacman -S python-pip
su f1
pip install --user dotbot


# install dotbot plugins that arent forks
# this is because I don't want to add dotbot or dotbot plugins as submodules
# NOTE: dotbot-pacaur comes with a pacaur bootstrap installer but it is broken - hence bootstrapping above
mkdir -p $HOME/.dotbot
git clone https://github.com/alexcormier/dotbot-rust $HOME/.dotbot/dotbot-rust
git clone https://github.com/wonderbeyond/dotbot-if $HOME/.dotbot/dotbot-if
git clone https://github.com/sobolevn/dotbot-pip $HOME/.dotbot/dotbot-pip
git clone https://github.com/delicb/dotbot-golang $HOME/.dotbot/dotbot-golang
git clone https://github.com/oxson/dotbot-yay $HOME/.dotbot/dotbot-yay

echo "run dotbot config now"

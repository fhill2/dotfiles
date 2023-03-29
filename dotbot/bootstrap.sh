# this script needs to be only run once on a new arch install
# this assumes I have installed with the arch automated installer
# https://wiki.archlinux.org/title/Archinstall



# install
if [ "$EUID" -ne 1000 ]
then echo "Please run as f1 user"
  exit
fi


# 1: Install SSH Key

# can be run as f1 user
#su f1 -c './ssh'
#source /home/f1/.ssh

ssh-keygen -b 2048 -t ed25519 -f ~/.ssh/gh-cli -q -N "" -C "freddiehill000@gmail.com"
ssh-keygen -b 2048 -t ed25519 -f ~/.ssh/id_ed25519 -q -N "" -C "freddiehill000@gmail.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519



su root
# if [ "$EUID" -ne 0 ]
# then echo "Please run as root"
#   exit
# fi

# 2: 
git config --global user.name "Freddie Hill"
git config --global user.email "freddiehill000@gmail.com"

systemctl enable --now reflector.service
systemctl enable reflector.timer

systemctl enable --now syncthing@f1.service


rm /home/f1/Sync # delete syncthing default folder

# now turn syncthing on
#xdg-open http://127.0.0.1:8384
# http://192.168.0.100:8384/syncthing/ <- for NAS syncthing config

echo "now do steps in manual.md"


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

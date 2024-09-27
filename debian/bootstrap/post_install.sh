# post_install
# post installation script after the package list has been installed...

# post install for sway otherwise sway shows Permission Denied errors on launch...
# This may not be necessary, try only installing seatd to see if it fixes the perm errors
# sudo apt install seatd
sudo useradd seat
sudo usermod -a -G seat $USER
sudo systemctl enable seatd.service

# Currently not working on debian...
# PAM Authentication Failure
# Set Login Shell to ZSH
sudo chsh -s $(which zsh) $USER

mkdir -p $HOME/.local # dir does not exist on a fresh debian install
echo "Replacing local bin with dotfiles bin..."
ln -s ~/dot/bin ~/.local/bin

# Generate SSH key as osx package list is in a shared private repo
# -C -> comment
ssh-keygen -t rsa -b 4096 -C "freddiehill000@gmail.com" -f "$HOME/.ssh/f_github"

eval "$(ssh-agent)"
ssh-add ~/.ssh/f_github



mkdir -p $HOME/.config

# https://gitlab.freedesktop.org/mesa/drm/-/issues/52#note_619180
# amd_gpu_initialized_failed error
# solution is to restart after the seat management daemon has been installed
echo "A Reboot is needed in order for sway to start"

mkdir -p $HOME/Desktop

# install google chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb

# Debian did not correctly set the locale on installation
# Shown when installing packages with apt
# https://serverfault.com/a/362910
# https://forums.debian.net/viewtopic.php?t=146922
echo 'LANG=en_GB.UTF-8' | sudo tee /etc/default/locale
sudo /usr/sbin/locale-gen # have to run locale-gen as root


# Manual Steps
# google-chrome tries to start in X11 when installed
# open google chrome with google-chrome --ozone-platform=wayland
# google chrome -> chrome://flags -> search for wayland - auto set always to wayland
# now "google-chrome" will start in wayland


# Install wezterm from .deb repo
# https://wezfurlong.org/wezterm/install/linux.html#__tabbed_1_3
# curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
# echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
# sudo apt update
# sudo apt install wezterm-nightly

# Install broot for Azlux .deb repo
# https://packages.azlux.fr/
echo "deb [signed-by=/usr/share/keyrings/azlux-archive-keyring.gpg] http://packages.azlux.fr/debian/ stable main" | sudo tee /etc/apt/sources.list.d/azlux.list
sudo wget -O /usr/share/keyrings/azlux-archive-keyring.gpg  https://azlux.fr/repo.gpg
sudo apt update
sudo apt install broot

# https://github.com/obsidianmd/obsidian-releases/releases/download/v1.6.7/obsidian_1.6.7_amd64.deb
# Install obsidian from .deb repo
# AppImage version of Obsidian is most likely to be the most reliable
# as issues / PRs have to be repro'd with the AppImage to be submitted
# the version downloaded probably doesn't matter, as Obsidian updates once installed
wget -O /tmp/obsidian_1.6.7_amd64.deb https://github.com/obsidianmd/obsidian-releases/releases/download/v1.6.7/obsidian_1.6.7_amd64.deb
sudo apt-get install /tmp/obsidian_1.6.7_amd64.deb

# Install fonts
# https://github.com/officialrajdeepsingh/nerd-fonts-installer
bash -c  "$(curl -fsSL https://raw.githubusercontent.com/officialrajdeepsingh/nerd-fonts-installer/main/install.sh)" 

# Install lazygit from binary package
wget -O /tmp/lazygit.tgz https://github.com/jesseduffield/lazygit/releases/download/v0.44.1/lazygit_0.44.1_Linux_x86_64.tar.gz
tar xvf /tmp/lazygit.tgz
sudo mv /tmp/lazygit /usr/local/bin/

mkdir -p ~/apps

# https://github.com/korreman/sway-overfocus
# Install sway-overfocus from source
git clone https://github.com/korreman/sway-overfocus ~/apps/sway-overfocus
cd ~/apps/sway-overfocus
cargo build --release
cp ./target/release/sway-overfocus ~/.local/bin/sway-overfocus


# start syncthing
sudo systemctl enable --now syncthing@f1.service


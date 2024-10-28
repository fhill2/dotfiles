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
sudo wget -O /usr/share/keyrings/azlux-archive-keyring.gpg https://azlux.fr/repo.gpg
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
bash -c "$(curl -fsSL https://raw.githubusercontent.com/officialrajdeepsingh/nerd-fonts-installer/main/install.sh)"

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

# https://www.jetbrains.com/help/datagrip/installation-guide.html#i4vtepn_145
# Oct 2024 - Can't get Wayland version of DataGrip to run
# Tried installing from source, snap, and Toolbox (appimage)
# Manually install Datagrip
# Download the .tar.gz from this link
# https://www.jetbrains.com/datagrip/download/#section=linux
sudo tar xzf ~/Downloads/datagrip-*.tar.gz -C /opt/
# Rename the directory to DataGrip (Important)

# obsidian requires xwayland
sudo apt install xwayland # now sway will start Xwayland with no additional configuration

sudo apt-get install sqlite3
# Now pkill sway and log back in
# Open with /opt/DataGrip/bin/datagrip.sh
# Now Tools > Generate Desktop Shortcut

# Install neovim from source
# https://github.com/neovim/neovim
mkdir -p ~/apps
git clone https://github.com/neovim/neovim ~/apps/neovim
ln -s ~/apps/neovim/build/bin/nvim ~/.local/bin/nvim

# Install heaptrack from source
# https://github.com/KDE/heaptrack?tab=readme-ov-file
git clone https://github.com/KDE/heaptrack ~/apps/heaptrack
sudo apt-get install elfutils libdw-dev libboost-all-dev
cd ~/apps/heaptrack && mkdir build && cd build
cmake -DCMAKE_BUILD_TYPE=Release
make -j$(nproc)
ln -s /home/f1/apps/heaptrack/bin/heaptrack ~/.local/bin/heaptrack

# Install moderncsv (manual)
# Download manually from https://www.moderncsv.com/
tar -xzvf ~/Downloads/filename.tar.gz
mv moderncsv2.x ~/apps/moderncsv2.x
cd moderncsv2.x
sudo install.sh

# Answer y to prompt saying that rust already exists on /usr/bin
# curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
sudo apt install rustup
rustup install nightly
rustup default nightly             # link to /usr
rustup component add rust-analyzer # install the version of rust_analyzer for rust

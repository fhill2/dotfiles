# This config is needed on Debian Server & Desktop...
# post_install
# post installation script after the package list has been installed...

##############################
### ESSENTIALS
# Currently not working on debian...
# PAM Authentication Failure
# Set Login Shell to ZSH
sudo chsh -s $(which zsh) $USER

# Essential - Otherwise $USER cannot sudo
sudo usermod -aG sudo $USER

# Install neovim from source
# https://github.com/neovim/neovim
mkdir -p ~/apps
git clone https://github.com/neovim/neovim ~/apps/neovim
make CMAKE_BUILD_TYPE=RelWithDebInfo CMAKE_INSTALL_PREFIX=/full/path/
make install
ln -s ~/apps/neovim/build/bin/nvim ~/.local/bin/nvim

# Answer y to prompt saying that rust already exists on /usr/bin
# curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# installing via apt did not work on f-server
# sudo apt install rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# f-server does not need nightly - TODO: conditional here
rustup install stable
rustup default stable              # link to /usr
rustup component add rust-analyzer # install the version of rust_analyzer for rust

# Generate SSH key as osx package list is in a shared private repo
# -C -> comment
ssh-keygen -t rsa -b 4096 -C "freddiehill000@gmail.com" -f "$HOME/.ssh/f_github"
eval "$(ssh-agent)"
ssh-add ~/.ssh/f_github

# https://github.com/korreman/sway-overfocus
# Install sway-overfocus from source
git clone https://github.com/korreman/sway-overfocus ~/apps/sway-overfocus
cd ~/apps/sway-overfocus
cargo build --release
cp ./target/release/sway-overfocus ~/.local/bin/sway-overfocus

# Install lazygit from binary package
wget -O /tmp/lazygit.tgz https://github.com/jesseduffield/lazygit/releases/download/v0.44.1/lazygit_0.44.1_Linux_x86_64.tar.gz
tar xvf /tmp/lazygit.tgz -C /tmp
sudo mv /tmp/lazygit /usr/local/bin/

##############################3
# https://gitlab.freedesktop.org/mesa/drm/-/issues/52#note_619180
# amd_gpu_initialized_failed error
# solution is to restart after the seat management daemon has been installed
# echo "A Reboot is needed in order for sway to start"

# install google chrome
# wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
# sudo apt install ./google-chrome-stable_current_amd64.deb
# https://itslinuxguide.com/install-google-chrome-debian-12/
curl -fSsL https://dl.google.com/linux/linux_signing_key.pub | sudo gpg --dearmor | sudo tee /usr/share/keyrings/google-chrome.gpg >>/dev/null
echo deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main | sudo tee /etc/apt/sources.list.d/google-chrome.list
sudo apt update
sudo apt install google-chrome-stable
# now launched with google-chrome-stable --ozone-platform=wayland
# chrome://flags -> search wayland -> set to Wayland

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
# 12 -> DejaVuSansMono -> The font to rule them all

# start syncthing
sudo systemctl enable --now syncthing@f1.service

sudo apt-get install sqlite3
# Now pkill sway and log back in
# Open with /opt/DataGrip/bin/datagrip.sh
# Now Tools > Generate Desktop Shortcut

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

# Install tailscale
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/noble.noarmor.gpg | sudo tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null
curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/noble.tailscale-keyring.list | sudo tee /etc/apt/sources.list.d/tailscale.list
sudo apt-get update
sudo apt-get install tailscale
sudo tailscale up

# Install pgadmin - postgresql GUI client
# Does not work
# https://www.pgadmin.org/download/pgadmin-4-apt/
# sudo curl https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo apt-key add
# sudo sh -c 'echo "deb https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/focal pgadmin4 main" \
#   > /etc/apt/sources.list.d/pgadmin4.list && apt update'
# sudo apt update
# sudo apt install pgadmin4
# sudo /usr/pgadmin4/bin/setup-web.sh
#
# Set password on postgres localhost database to avoid
# systemctl
sudo systemctl enable --now postgresql
sudo -u postgres psql postgres
# type into sql prompt: ALTER USER postgres WITH PASSWORD 'postgres'

# Install DBeaver
# sudo wget -O /usr/share/keyrings/dbeaver.gpg.key https://dbeaver.io/debs/dbeaver.gpg.key
# echo "deb [signed-by=/usr/share/keyrings/dbeaver.gpg.key] https://dbeaver.io/debs/dbeaver-ce /" | sudo tee /etc/apt/sources.list.d/dbeaver.list
# sudo apt-get update && sudo apt-get install dbeaver-ce
wget https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb -P /tmp
sudo apt install /tmp/dbeaver-ce_latest_amd64.deb

systemctl --user enable --now gammastep.service

# Install IB Gateway
wget -O /tmp/ibgateway-stable-standalone-linux-x64.sh https://download2.interactivebrokers.com/installers/ibgateway/stable-standalone/ibgateway-stable-standalone-linux-x64.sh
chmod +x /tmp/ibgateway-stable-standalone-linux-x64.sh
/tmp/ibgateway-stable-standalone-linux-x64.sh

# Configure Samba
# Type in password at prompt, a user will be setup
sudo smbpasswd -a f1

# https://github.com/sayanarijit/xplr/issues/667
cargo install --locked xplr

# if host is f-server-g
# install haskell stack to install kmonad
curl -sSL https://get.haskellstack.org/ | sh

# Not using diesel-cli anymore...
# Install diesel_cli deps and then diesel-cli
# sudo apt install librust-mysqlclient-sys-dev
# sudo apt install libpq-dev
# cargo install diesel_cli --features sqlite

cargo install py-spy

# fd debian package is called fdfind
# neovim-telescope-file-browser.nvim requires fd binary on path with exact name as fd
# other the plugin falls back to find
sudo ln -s /usr/bin/fdfind /usr/bin/fd

# Download Vesktop - Discord Alternative
wget -O /tmp/vesktop https://vencord.dev/download/vesktop/amd64/deb
sudo dpkg -i /tmp/vesktop

# Kanata install
# https://github.com/jtroo/kanata/blob/main/docs/setup-linux.md
# might require a restart after all these commands
cargo install kanata
sudo groupadd uinput
sudo usermod -aG input $USER
sudo usermod -aG uinput $USER
sudo udevadm control --reload-rules && sudo udevadm trigger #
sudo modprobe uinput
systemctl --user daemon-reload
systemctl --user enable kanata.service
systemctl --user start kanata.service
systemctl --user status kanata.service # check whether the service is running
sudo chmod +x /etc/init.d/kanata       # script must be executable

# Install Aeron
# install java first
sudo apt install openjdk-17-jdk
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64 # Replace with the actual path if different
export PATH=$JAVA_HOME/bin:$PATH
git clone https://github.com/aeron-io/aeron ~/apps/aeron
cd aeron

mkdir -p cppbuild/Debug
cd cppbuild/Debug
cmake -DCMAKE_BUILD_TYPE=Debug ../..
cmake --build . --clean-first
ctest

cargo install cargo-watch

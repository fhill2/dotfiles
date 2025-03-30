# Install wezterm from .deb repo
# https://wezfurlong.org/wezterm/install/linux.html#__tabbed_1_3
# curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
# echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list
# sudo apt update
# sudo apt install wezterm-nightly
#
#
# Install Davince Resolve with 6800 XT GPU
# Download and install
# I had to create the deb from the linux official download
# SKIP_PACKAGE_CHECK=1 ./DaVinci_Resolve_19.1.2_Linux.run
https://www.danieltufvesson.com/makeresolvedeb
https://archive.debian.org/debian/pool/main/libj/libjpeg8/libjpeg8-dev_8b-1_amd64.deb
sudo apt install mesa-opencl-icd

# This is not necessary if seatd is installed before launching sway...
# post install for sway otherwise sway shows Permission Denied errors on launch...
# sudo useradd seat
# sudo usermod -a -G seat $USER
# sudo systemctl enable seatd.service
#
#
# Note: on f-server dec 2024 install
# locale gets set correctly if the correct region is given in the installation
# Debian did not correctly set the locale on installation
# Shown when installing packages with apt
# https://serverfault.com/a/362910
# https://forums.debian.net/viewtopic.php?t=146922
# echo 'LANG=en_GB.UTF-8' | sudo tee /etc/default/locale
# sudo /usr/sbin/locale-gen # have to run locale-gen as root
#
#
# https://www.jetbrains.com/help/datagrip/installation-guide.html#i4vtepn_145
# Oct 2024 - Can't get Wayland version of DataGrip to run
# Tried installing from source, snap, and Toolbox (appimage)
# Manually install Datagrip
# Download the .tar.gz from this link
# https://www.jetbrains.com/datagrip/download/#section=linux
sudo tar xzf ~/Downloads/datagrip-*.tar.gz -C /opt/
# Rename the directory to DataGrip (Important)

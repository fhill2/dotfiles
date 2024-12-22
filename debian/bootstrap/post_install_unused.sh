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

# https://gitlab.winehq.org/wine/wine/-/merge_requests/5177
# https://gitlab.winehq.org/wine/wine/-/releases/wine-9.0
# Install lutris for DAOC on Linux
# https://lutris.net/downloads
echo "deb [signed-by=/etc/apt/keyrings/lutris.gpg] https://download.opensuse.org/repositories/home:/strycore/Debian_12/ ./" | sudo tee /etc/apt/sources.list.d/lutris.list >/dev/null
wget -q -O- https://download.opensuse.org/repositories/home:/strycore/Debian_12/Release.key | gpg --dearmor | sudo tee /etc/apt/keyrings/lutris.gpg >/dev/null
sudo apt update

# Fix was to install wine 10.0 from SID Unstable

# have to be on SID + for this to work
# dpkg --add-architecture i386 && apt-get update &&
# 	apt-get install wine32:i386
#
# sudo apt install lutris gamemode wine
#
# # run lutris in terminal and check for errors
# #
# # # https://gitlab.archlinux.org/archlinux/packaging/packages/wine/-/issues/11
#
# # https://github.com/FeralInteractive/gamemode/issues/254#issuecomment-1317794732
# #
# # wget https://packages.debian.org/sid/amd64/gamemode/download
# # wget https://packages.debian.org/sid/amd64/gamemode-daemon/download -O gamemode-daemon.deb
# # https://packages.debian.org/sid/amd64/libgamemode0/download
# # https://packages.debian.org/sid/amd64/libgamemodeauto0/download
# # https://packages.debian.org/sid/i386/libgamemode0/download
# # https://packages.debian.org/sid/i386/libgamemodeauto0/download
# #
#
# # Installing into System wine instead of a lutris bottled wine
# https://eden-daoc.net/viewtopic.php?p=9114
# wget "https://eden-daoc.net/EdenLauncher.msi" --directory-prefix="Downloads/"
# wget "https://darkageofcamelot.com/sites/daoc/files/downloads/DAoCSetup.exe" --directory-prefix="Downloads/"
# wine ~/Downloads/DAoCSetup.exe
#
# # install winetricks using bash script from winetricks github repo
# winetricks dotnet40
# wine ~/Downloads/EdenLauncher.msi
#
#

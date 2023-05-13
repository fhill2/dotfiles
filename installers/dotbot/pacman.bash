#!/bin/bash
arch_desk_pacman_pkgs=("mesa")

arch_lap_pacman_pkgs=(
  # nvidia proprietary
  "nvidia"
  "nvidia-utils"
  "nvidia-settings"
  "an-arch-lap-pkg"

  # otherwise external monitor HDMI sound outputs do not show in pavucontrol / pulseaudio
  "sof-firmware" 

)

shared_pacman_pkgs=(

   # for the most minimal gnome install
    "gnome-session"
    "gnome-shell"

  "nodejs"
  "python"
  "kitty"
  "git"  
  "dunst"
  "jq"

  "rofi-emoji"
  "firefox-nightly-bin"

  "net-tools" # netstat


  # x only screenshots
  "maim"

  # a dependency for npm-check or pacman npm-check-updates
  # to easily update npm project dependencies
  "pnpm"

  "sxhkd"



  # for x11 config only wayland uses wl_gammarelay_rs as this is the only screen brightness temp app that hooks into i3status-rs with live updates
  "redshift"



  # for floating point math in bash
  "bc"

  
  # x specific
  "xorg-xinit"
  "xorg-server"
  "xorg-xwininfo"
  "xorg-xev"
  # for vlc.lua link script
  "wmctrl"
  
  # gpu performance monitoring (for each driver)
  "intel-gpu-tools"

  "gpg-tui" # failed to build using cargo
  "pass"


  # pulseaudio scripting replaced with pipewire
  # pulseaudio
  # pamixer

  "lazygit"

  # networking
  "nmap"

  # gnu-netcat does not have -U option for vlc link script
  "openbsd-netcat"

  # file manager
  "nemo"
  # otherwise no nemo context menu "extract here"
  "nemo-fileroller"

  "rofi-calc"
  
  # https://github.com/nana-4/materia-theme
  # trying out a material theme, instead of material base64 theme
  # as gtk base64 FlatColour does not work as well as I want it (cant see selection)
  "materia-gtk-theme"

  "vlc"
  # blender
  "i3-wm"

  # ============== AUR PACKAGES START HERE ==========
  "i3status-rust-git"

  "bluez"
  "bluez-utils"
  "bluetuith" # tui bluetooth manager
  
  # needed for current version of corsair udev
  "xpub"
  "kmonad-bin"
  "xmousepasteblock-git"
  "mons"
  # i3status-rs lists its dependencies in the aur package and they are not installed automatically
  # installing i3status-rs through cargo does not install the correct files into /usr/share/i3status-rs for icons and themes to work
  "ttf-font-awesome"
  "upower"
  "speedtest-cli"

  # sourcegraph installed this manually as validation did not pass
  # had to install with yay -S --mflags '--skipchecksums' -S src-cli-bin
  "src-cli-bin"

  # work
  "slack-desktop"

  # 3d animation
  "unityhub-beta"

  # pacman preview_tui dependencies
  "less"
  "tree"
  "mediainfo"
  "unzip"
  "unrar"
  "man-db"
  "tar"
  "imagemagick"
  "ffmpegthumbnailer"
  "ffmpeg"
  "libreoffice-fresh"
  "poppler"

  # gnome-epub-thumbnailer
  "glow"
  "w3m"

  # pacman dependencies
  # detects AUR packages that need to be rebuilt after upgrading system packages (very useful) 
  # checks if AUR packages can find the requires shared link libraries
  "rebuild-detector"

  "syncthing"


  # aur preview_tui dependencies
  # pistol-git
  # fontpreview

  # aur monitor brightness control
  "ddccontrol-db-git"
  "ddccontrol"

  # for file sharing
  "samba"
  # for mounting smb shares using spaceFM spaceFm dependency
  "udevil"

  
  # configuration for materia-gtk-theme is done with this
  "themix-gui-git"

  "pandoc-cli"
  # install microsoft default installed fonts for web dev
  "ttf-ms-win10-auto"
  # to use with rofi-emoji
  "noto-fonts-emoji"

  # nfs server and client
  "nfs-utils"

  "bitwarden" # electron bitwarden GUI - CLI installed via npm
  "pet"
)

# super+space -> ulauncher
gsettings set org.gnome.settings-daemon.plugins.media-keys custom-keybindings \
  "['/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/']"
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ \
  name 'Ulauncher'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ \
  command 'ulauncher-toggle'
gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/ \
  binding '<Super>space'


gsettings set org.gnome.nautilus.preferences default-folder-viewer 'list-view'
gsettings set org.gnome.nautilus.list-view default-zoom-level 'small'


# always prefer dark settings for gnome apps
# settings, nautilus etc
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'


# Disable ALL compositor animations
# Disables animation when switching workspaces
# and also animation showing the activites overview
gsettings set org.gnome.desktop.interface enable-animations false



# Set background to black
# 1. Set the background picture to nothing (removes the default wallpaper)
gsettings set org.gnome.desktop.background picture-uri ''
gsettings set org.gnome.desktop.background picture-uri-dark ''
# 2. Set the primary background color to pure black
gsettings set org.gnome.desktop.background primary-color '#000000'
# 3. Ensure the color shading type is set to 'solid'
gsettings set org.gnome.desktop.background color-shading-type 'solid'


# Energy
# tell GNOME's power management daemon to never initiate sleep due to inactivity, regardless of power source (AC or Battery).
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type 'nothing'
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type 'nothing'

# I want the display to sleep - but the system to stayt awake.
gsettings set org.gnome.settings-daemon.plugins.power idle-dim true
gsettings set org.gnome.desktop.session idle-delay 600
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-timeout 0

# Disable the lock screen entirely
gsettings set org.gnome.desktop.screensaver lock-enabled false
# Disable locking when the system suspends (if you trigger it manually)
gsettings set org.gnome.desktop.screensaver ubuntu-lock-on-suspend false
# Ensure the lock screen cannot be triggered via the lockdown schema
gsettings set org.gnome.desktop.lockdown disable-lock-screen true


# Time & Timezone
# Keep the system clock accurate via NTP and let GNOME auto-set the timezone
# from geoclue (WiFi/IP location). DST (e.g. BST <-> GMT) is handled
# automatically by tzdata for whichever zone is set.
# - set-ntp enables systemd-timesyncd (keeps the clock synced)
# - set-timezone sets the fallback / immediate zone (Europe/London);
#   geoclue refines/overrides it by detected location
# - automatic-timezone enables GNOME's Automatic Time Zone toggle
sudo timedatectl set-ntp true
sudo timedatectl set-timezone Europe/London
gsettings set org.gnome.desktop.datetime automatic-timezone true

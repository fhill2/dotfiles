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

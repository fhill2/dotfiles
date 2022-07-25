# When using a display manager, these environment variables might not be loaded, as the login shell can be skipped, and the window manager is run instead.
# When using startx/initx (current setup), login shell is always executed
# note ~/.profile is only run when entering a sh login shell, or a bash login shell without any user bash init files existing in the home folder (.bash_profile)
# zsh doesn't ever run ~/.profile, it only runs ~/.zprofile



export QT_QPA_PLATFORMTHEME=qt5ct
export QT_AUTO_SCREEN_SCALE_FACTOR=0

export PATH=/home/f1/dev/bin:/home/f1/.cargo/bin:/home/f1/dev/cl/shell/scripts:/home/f1/.local/bin:$PATH
export EDITOR=nvim
export SHELL=zsh




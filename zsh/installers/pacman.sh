
function pac_is_installed() {
    ! is_arch && return 1
    local package=$1
    pacman -Qs "$package"
}

# yay instead of pacman, to install AUR and pacman packages with a single command
function pac_install() {
    ! is_arch && return 1
    local package=$1
    if pac_is_installed "$package"; then
    dotsay "+ $package already installed... skipping."
  else
    yay -S --noconfirm "$package"
  fi

}
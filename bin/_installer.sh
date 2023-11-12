#!/usr/bin/env bash


# ========== aptitude ==========
function apt_update() {
  ! is_linux && return 1

  sudo apt-get update
}

function apt_is_installed() {
  ! is_linux && return 1

  local package=$1

  dpkg -s "$package" >/dev/null 2>&1
}

function apt_install() {
  ! is_linux && return 1

  local package=$1

  if apt_is_installed "$package"; then
    dotsay "+ $package already installed... skipping."
  else
    sudo apt-get install -y "$package"
  fi
}

# ========== aptitude ==========
function dotfiles_config_set() {
  local key=$1

  [ -f ~/.config/dotfiles/$key ]
}

function use_rbenv() {
  dotfiles_config_set "rbenv"
}

function use_rvm() {
  ! use_rbenv
}

function use_nodenv() {
  dotfiles_config_set "no-nvm"
}

function use_nvm() {
  ! use_nodenv
}



# ========== dev-packages.sh ==========

# wrappers for programming language installers
# npm, cargo, python pip, go 


# If the package is already installed, npm will not reinstall it. 
# wrapped in if statement as command produces noise if package is installed.
npm_install() {
local package=$1
 if ! command_exists "$package"; then
 npm install -g "$package"
 else
  dotsay "+ $package already installed... skipping."
 fi
   
}

pip_install() {
local package=$1
python3 -m pip install $package

}

# go_install() {

# }


# If the package is already installed, Cargo will not reinstall it. 
# Instead, it will print the following output:
# Package <package_name> is already installed.
cargo_install() {  
    local package=$1
	if ! command_exists "$package"; then
		cargo install $package
	fi
}

# ========== homebrew ==========


arm64_packages=(
  neovim
  ninja
  node-build
  rbenv
)

function contains_element() {
  local e match="$1"
  shift
  for e; do [[ "$e" == "$match" ]] && return 0; done
  return 1
}

function brew_is_tapped() {
  local tap=$1

  ! is_macos && return 1

  brew tap | grep -q "$tap"
}

function brew_tap_install() {
  local tap=$1

  ! is_macos && return 1

  brew tap "$tap"
}

function brew_install() {
  local package=$1

  ! is_macos && return 1

  if brew list "$package" > /dev/null 2>&1; then
    dotsay "+ $package already installed... skipping."
  else
    if contains_element "$package" "${arm64_packages[@]}"; then
      arch -arm64 brew install $@
    else
      brew install $@
    fi
  fi
}

function brew_upgrade() {
  local package=$1

  ! is_macos && return 1

  dotsay "+ $package already installed... skipping."

  if contains_element "$package" "${arm64_packages[@]}"; then
    arch -arm64 brew upgrade $@
  else
    brew upgrade $@
  fi
}

function brew_cask_install() {
  local package=$1

  ! is_macos && return 1

  if brew list "$package" > /dev/null 2>&1; then
    dotsay "+ $package already installed... skipping."
  else
    brew install --cask $@
  fi
}

function brew_install_all() {
  local packages=("$@")

  ! is_macos && return 1

  for package in "${packages[@]}"; do
    brew_install $package
  done
}

# ========== os-detection ==========

# _current_os=$(uname) # Linux or Darwin

function detect_os() {
  if [ "$(uname -s)" == "Darwin" ]; then
    echo "Darwin"
  elif command -v "pacman" >/dev/null 2>&1; then
  echo "Arch"
  elif command -v "apt" >/dev/null 2>&1; then
    echo "Debian"
  fi
}

_current_os=$(detect_os)


function is_macos() {
  [[ "$_current_os" == "Darwin" ]]
}
function is_linux() {
 [[ "$_current_os" == "Arch" || "$_current_os" == "Debian" ]]
}

function is_arch() {
  [[ "$_current_os" == "Arch" ]]
}

function is_debian() {
  [[ "$_current_os" == "Debian" ]]
}

# ========== packages.sh ==========

# Use this when the names are the same
function install_package() {
  local name=$1
  if is_macos; then
    brew_install "$name"
  elif is_arch; then
    pac_install "$name"
  elif is_debian; then
    apt_install "$name"
  fi
}

linux_install() {
  ! is_linux && return 1
  if is_arch; then
    pac_install "$name"
  elif is_debian; then
    apt_install "$name"
  fi
}

# ========== pacman.sh ==========

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


# ========== require.sh ==========
# declare -a _required_installers=()

# function array_contains() {
#     local n=$#
#     local value=${!n}
#     for ((i=1;i < $#;i++)) {
#         if [ "${!i}" == "${value}" ]; then
#             echo "y"
#             return 0
#         fi
#     }
#     echo "n"
#     return 1
# }

# function require_installer() {
#   local name=$1
#   local installer_path="$(dotfiles_location)/installers/$name"

#   # Don't include installers twice
#   if [ ! $(array_contains "${_required_installers[@]}" "$name") == "y" ]; then
#     source $installer_path

#     dotsay "@b@blue[[+ Done!]]"
#     echo
#   fi

#   _required_installers+=("$name")

#   return 0
# }

# ========== stdout.sh ==========
dotheader() {
  dotsay "@b@green[[$1]]"
  echo
}

dotsay() {
  local result=$(_colorized $@)
  echo "$result"
}

_colorized() {
   echo "$@" | sed -E \
     -e 's/((@(red|green|yellow|blue|magenta|cyan|white|reset|b|u))+)[[]{2}(.*)[]]{2}/\1\4@reset/g' \
     -e "s/@red/$(tput setaf 1)/g" \
     -e "s/@green/$(tput setaf 2)/g" \
     -e "s/@yellow/$(tput setaf 3)/g" \
     -e "s/@blue/$(tput setaf 4)/g" \
     -e "s/@magenta/$(tput setaf 5)/g" \
     -e "s/@cyan/$(tput setaf 6)/g" \
     -e "s/@white/$(tput setaf 7)/g" \
     -e "s/@reset/$(tput sgr0)/g" \
     -e "s/@b/$(tput bold)/g" \
     -e "s/@u/$(tput sgr 0 1)/g"
}


# ========== symlinks.sh ==========


# _symlinks_current_dir="${BASH_SOURCE%/*}"

# function dotfiles_location() {
#   echo $(cd $_symlinks_current_dir/../.. && pwd)
# }

function dotfiles_location() {
  echo "$HOME/dot"
}

# function _symlink() {
#     # Get the name of the symlink
# source=$1
# destination=$2

#   # if file exists
#   if [ -e "$destination" ]; then
  
# # Get the path to the original file
# original_file=$(readlink -f "$symlink")

# # Check if the original file exists
# if [ ! -f "$original_file" ]; then
#   # if the original file does not exist...

#   # Prompt the user if they want to delete the symlink
#   echo "$destination original file: $original_file - does not exist. Do you want to delete $destination?"
#   read -n 1 -r -p "(y/N) " response

#   # Delete the symlink if the user said yes
#   if [[ $response =~ [Yy] ]]; then
#     rm "$destination"
#   fi
# fi

#   else
#     echo "Symlinking $source -> $destination"
#     mkdir -p "$(dirname "$destination")"


#     # Try to create the symlink
#   if ln -s "$source" "$destination"; then
#     return 0
  
#     # If the symlink failed, try again as sudo
#   echo "Symlink failed - Sudo Symlinking $source -> $destination?"
#   read -n 1 -r -p "(y/N): " response
#   echo ""
#   if [[ $response =~ [Yy] ]]; then
#   sudo mkdir -p "$(dirname "$destination")"
#   sudo ln -s "$source" "$destination"
#   fi
#   fi
#   fi
# }

# function symlink_dotfile() {
#   # symlink_dotfile - always relative to the dotfiles location
#   _symlink "$(dotfiles_location)/$1" "$2"
# }

# function symlink_relative_dotfile() {
#   _symlink "$(pwd)/$1" "$2"
# }

# function symlink_absolute_dotfile() {
#   # always pass in absolute source and target
#   _symlink "$1" "$2"
# }
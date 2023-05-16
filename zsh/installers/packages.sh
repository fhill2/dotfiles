#!/usr/bin/env bash

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




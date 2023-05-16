#!/usr/bin/env bash

_current_os=$(uname) # Linux or Darwin

detect_os() {
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

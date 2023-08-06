#!/usr/bin/env bash

# Credit: originally from @dbalatero's dotfiles

# Credit: adapted from @alrra's dotfiles at:
#
#   https://raw.githubusercontent.com/alrra/dotfiles/master/src/os/install/macos/xcode.sh
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# fhill2:
# this is a script that is meant to be run after a fresh install of osx or linux.
# before the installers
# it combines scripts from these locations of @dbalatero's dotfiles:
# bootstrap.sh -> contains
# installers/package-manager -> installs homebrew or aptitude

# installers/shared/homebrew.sh -> to

# ========================
# Setup / Configuration that still needs to be automated:
# - Setup f1 account
# - Change keyboard layout to international PC
# =======================

source "${BASH_SOURCE%/*}/installers/shared.sh"
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
ask() {
	print_question "$1"
	read -r
}

print_question() {
	print_in_yellow "   [?] $1"
}

get_answer() {
	printf "%s" "$REPLY"
}

cmd_exists() {
	command -v "$1" &>/dev/null
}

set_trap() {
	trap -p "$1" | grep "$2" &>/dev/null ||
		trap '$2' "$1"
}

print_header() {
	print_in_purple "\n • $1\n\n"
}

show_spinner() {
	local -r FRAMES='/-\|'

	# shellcheck disable=SC2034
	local -r NUMBER_OR_FRAMES=${#FRAMES}

	local -r CMDS="$2"
	local -r MSG="$3"
	local -r PID="$1"

	local i=0
	local frameText=""

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

	# Note: In order for the Travis CI site to display
	# things correctly, it needs special treatment, hence,
	# the "is Travis CI?" checks.

	if [ "$TRAVIS" != "true" ]; then
		# Provide more space so that the text hopefully
		# doesn't reach the bottom line of the terminal window.
		#
		# This is a workaround for escape sequences not tracking
		# the buffer position (accounting for scrolling).
		#
		# See also: https://unix.stackexchange.com/a/278888

		printf "\n\n\n"
		tput cuu 3

		tput sc
	fi

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

	# Display spinner while the commands are being executed.

	while kill -0 "$PID" &>/dev/null; do
		frameText="   [${FRAMES:i++%NUMBER_OR_FRAMES:1}] $MSG"

		# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

		# Print frame text.

		if [ "$TRAVIS" != "true" ]; then
			printf "%s\n" "$frameText"
		else
			printf "%s" "$frameText"
		fi

		sleep 0.2

		# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

		# Clear frame text.

		if [ "$TRAVIS" != "true" ]; then
			tput rc
		else
			printf "\r"
		fi

	done
}

kill_all_subprocesses() {
	local i=""

	for i in $(jobs -p); do
		kill "$i"
		wait "$i" &>/dev/null
	done
}

execute() {
	local -r CMDS="$1"
	local -r MSG="${2:-$1}"
	local -r TMP_FILE="$(mktemp /tmp/XXXXX)"

	local exitCode=0
	local cmdsPID=""

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

	# If the current process is ended,
	# also end all its subprocesses.

	set_trap "EXIT" "kill_all_subprocesses"

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

	# Execute commands in background

	eval "$CMDS" \
		&>/dev/null \
		2>"$TMP_FILE" &

	cmdsPID=$!

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

	# Show a spinner if the commands
	# require more time to complete.

	show_spinner "$cmdsPID" "$CMDS" "$MSG"

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

	# Wait for the commands to no longer be executing
	# in the background, and then get their exit code.

	wait "$cmdsPID" &>/dev/null
	exitCode=$?

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

	# Print output based on what happened.

	print_result $exitCode "$MSG"

	if [ $exitCode -ne 0 ]; then
		print_error_stream <"$TMP_FILE"
	fi

	rm -rf "$TMP_FILE"

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

	return $exitCode
}

print_success() {
	print_in_green "   [✔] $1\n"
}

print_error() {
	print_in_red "   [✖] $1 $2\n"
}

print_in_color() {
	printf "%b" \
		"$(tput setaf "$2" 2>/dev/null)" \
		"$1" \
		"$(tput sgr0 2>/dev/null)"
}

print_in_green() {
	print_in_color "$1" 2
}

print_in_purple() {
	print_in_color "$1" 5
}

print_in_red() {
	print_in_color "$1" 1
}

print_in_yellow() {
	print_in_color "$1" 3
}

print_result() {
	if [ "$1" -eq 0 ]; then
		print_success "$2"
	else
		print_error "$2"
	fi

	return "$1"
}

# are_xcode_command_line_tools_installed() {
#   xcode-select --print-path &> /dev/null
# }

# install_xcode_command_line_tools() {
#   # If necessary, prompt user to install
#   # the `Xcode Command Line Tools`.

#   xcode-select --install &> /dev/null

#   # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#   # Wait until the `Xcode Command Line Tools` are installed.

#   execute \
#     "until are_xcode_command_line_tools_installed; do \
#     sleep 5; \
#   done" \
#   "Xcode Command Line Tools"
# }

# ssh - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

add_ssh_configs() {
	printf "%s\n" \
		"Host github.com" \
		"  IdentityFile $1" \
		"  LogLevel ERROR" >>~/.ssh/config

	print_result $? "Add SSH configs"
}

copy_public_ssh_key_to_clipboard() {
	if cmd_exists "pbcopy"; then
		pbcopy <"$1"
		print_result $? "Copy public SSH key to clipboard"
	elif cmd_exists "xclip"; then
		xclip -selection clip <"$1"
		print_result $? "Copy public SSH key to clipboard"
	else
		print_warning "Please copy the public SSH key ($1) to clipboard"
	fi
}

generate_ssh_keys() {

	ask "Please provide an email address: " && printf "\n"
	ssh-keygen -t rsa -b 4096 -C "$(get_answer)" -f "$1"

	print_result $? "Generate SSH keys"

}

open_github_ssh_page() {
	declare -r GITHUB_SSH_URL="https://github.com/settings/ssh"

	# The order of the following checks matters
	# as on Ubuntu there is also a utility called `open`.

	if cmd_exists "xdg-open"; then
		xdg-open "$GITHUB_SSH_URL"
	elif cmd_exists "open"; then
		open "$GITHUB_SSH_URL"
	else
		print_warning "Please add the public SSH key to GitHub ($GITHUB_SSH_URL)"
	fi
}

set_github_ssh_key() {
	local sshKeyFileName="$HOME/.ssh/github"

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

	# If there is already a file with that
	# name, generate another, unique, file name.

	if [ -f "$sshKeyFileName" ]; then
		sshKeyFileName="$(mktemp -u "$HOME/.ssh/github_XXXXX")"
	fi

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

	generate_ssh_keys "$sshKeyFileName"
	add_ssh_configs "$sshKeyFileName"
	copy_public_ssh_key_to_clipboard "${sshKeyFileName}.pub"
	open_github_ssh_page
	test_ssh_connection
}

test_ssh_connection() {
	while true; do
		ssh -T git@github.com &>/dev/null
		[ $? -eq 1 ] && break

		sleep 5
	done
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

setup_ssh_keys() {
	print_header "Set up GitHub SSH keys"

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

	ssh -T git@github.com &>/dev/null

	if [ $? -ne 1 ]; then
		set_github_ssh_key
	fi

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

	print_result $? "Set up GitHub SSH keys"
}

# hostname ---------------------------------------

setup_hostname() {
	print_header "Set computer hostname"

	if [[ $(scutil --get HostName 2>/dev/null) == "" ]]; then
		ask "Please enter a hostname: "
		local new_hostname=$(get_answer)

		sudo scutil --set ComputerName "$new_hostname"
		sudo scutil --set LocalHostName "$new_hostname"
		sudo scutil --set HostName "$new_hostname"

		dscacheutil -flushcache

		print_success "Set hostname to $new_hostname"
	else
		print_success "Already set hostname to $(hostname)!"
	fi
}

install_package_manager() {
	if [ "$(uname -s)" == "Darwin" ]; then
		if test ! $(which brew); then

			echo "Installing Homebrew..."
			/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
			eval "$(/opt/homebrew/bin/brew shellenv)"

			brew update
			brew install git
		fi

	else
		if test ! $(which pacman); then
			# if ! pacman -Qe yay > /dev/null 2>&1; then
			echo "Installing yay..."
			mkdir -p ~/tmp
			original_directory=$(pwd)
			# git & base-devel packages are requirements, and are installed with arch-ext4 install script
			cd ~/tmp
			git clone https://aur.archlinux.org/yay.git && cd yay && makepkg -si
			cd "$original_directory"
		else
			echo "Setting up Aptitude..."
			apt_install aptitude

			# Apt build

			buildtools=(
				make
				cmake
				build-essential
				libssl-dev
				zlib1g-dev
				libbz2-dev
				libreadline-dev
				libsqlite3-dev
				wget
				curl
				llvm
				libncurses5-dev
				xz-utils
				tk-dev
			)

			for package in "${buildtools[@]}"; do
				apt_install "$package"
			done

		fi
	fi
}

setup_user_gitconfig() {
	# if [ ! -f ~/.gitconfig.user ]; then
	printf "What is your GitHub username? > "
	read github_user
	git config --global github.user "$github_user"

	printf "What is your full name for commit messages (e.g. Jane Smith)? > "
	read git_name
	git config --global user.name "$git_name"

	printf "What is your email address? > "
	read git_email
	git config --global user.email "$git_email"
	# fi
}

replace_local_bin_with_dotfiles_bin() {
	echo "Replacing local bin with dotfiles bin..."
	symlink_dotfile bin ~/.local/bin
}

clear_password_policies() {
	echo "clearing osx default password policies (minimum password length req)..."
	sudo pwpolicy -clearaccountpolicies
	# change user pass temporarily
	sudo dscl . -merge /Users/f1 UserShellInfo:. .
}

clone_dotfiles() {
  echo "Cloning dotfiles"
  git clone git@github.com:fhill2/dotfiles.git ~/dot
}

main() {
	# install_xcode_command_line_tools
	clear_password_policies
	setup_ssh_keys
	setup_hostname
	install_package_manager
	setup_user_gitconfig
	# install requirements for defaults script here

	# Bootstrap
	mkdir -p $HOME/.config
}

main

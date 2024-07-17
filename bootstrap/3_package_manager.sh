install_package_manager() {
	if [ "$(uname -s)" == "Darwin" ]; then
		if test ! $(which brew); then

			echo "Installing Homebrew..."
			/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
			(
				echo
				echo 'eval "$(/opt/homebrew/bin/brew shellenv)"'
			) >>/Users/s1/.zprofile
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

install_package_manager

# Run before the main Brewfile install
	if test ! $(which brew); then
		echo "Installing Homebrew..."
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
		(
			echo
			echo 'eval "$(/opt/homebrew/bin/brew shellenv)"'
		) >>/Users/s1/.zprofile
		eval "$(/opt/homebrew/bin/brew shellenv)"
		brew update
    # to upload ssh key
		brew install git
    brew install google-chrome
	fi
}



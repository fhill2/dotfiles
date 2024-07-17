replace_local_bin_with_dotfiles_bin() {
	echo "Replacing local bin with dotfiles bin..."
	ln -s ~/dot/bin ~/.local/bin
}

function setup_zsh_symlinks() {
	ln -s ~/dot/config/zsh/zshrc ~/.zshrc
	ln -s ~/dot/config/zsh ~/.zsh
	ln -s ~/dot/config/zsh/zshenv ~/.zshenv
	ln -s ~/dot/config/zsh/zprofile ~/.zprofile
	ln -s ~/dot/config/profile ~/.profile
	if [[ "$(uname -s)" == "Darwin" ]]; then
		ln -s ~/dot/config/profile_osx ~/.profile
	else
		ln -s ~/dot/config/profile_linux ~/.profile
	fi
	source ~/.zshrc
}

mkdir -p $HOME/.config

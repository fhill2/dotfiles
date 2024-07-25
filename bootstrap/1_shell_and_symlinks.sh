function chsh_zsh() {
	if [[ "$SHELL" != "$(zsh_binary)" ]]; then
		echo "Changing shell for $current_user..."

		local current_user=$USER
		sudo chsh -s $(zsh_binary) $current_user
	fi
}

mkdir -p $HOME/.config
setup_zsh_symlinks

echo "Replacing local bin with dotfiles bin..."
ln -s ~/dot/bin ~/.local/bin

# Generate SSH key as osx package list is in a shared private repo
# -C -> comment

ssh-keygen -t rsa -b 4096 -C "freddiehill000@gmail.com" -f "$HOME/.ssh/f_github"
ssh-add ~/.ssh/f_github

function setup_zsh_symlinks() {
	ln -s ~/dot/config/zsh/zshrc ~/.zshrc
	ln -s ~/dot/config/zsh ~/.zsh
	ln -s ~/dot/config/zsh/zshenv ~/.zshenv
	ln -s ~/dot/config/zsh/zprofile ~/.zprofile
	if [[ "$(uname -s)" == "Darwin" ]]; then
		ln -s ~/dot/config/profile_osx ~/.profile
	else
		ln -s ~/dot/config/profile_linux ~/.profile
	fi
	source ~/.zshrc
}

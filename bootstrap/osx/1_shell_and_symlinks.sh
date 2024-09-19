mkdir -p $HOME/.local # dir does not exist on a fresh debian install
echo "Replacing local bin with dotfiles bin..."
ln -s ~/dot/bin ~/.local/bin

# Generate SSH key as osx package list is in a shared private repo
# -C -> comment
ssh-keygen -t rsa -b 4096 -C "freddiehill000@gmail.com" -f "$HOME/.ssh/f_github"

eval "$(ssh-agent)"
ssh-add ~/.ssh/f_github

function setup_zsh_symlinks() {
	ln -s ~/dot/config/zsh/zshrc ~/.zshrc
	ln -s ~/dot/config/zsh ~/.zsh
	ln -s ~/dot/config/zsh/zshenv ~/.zshenv
	ln -s ~/dot/config/profile_osx ~/.profile
	# unnecessary to source ~/.zshrc at this point
	# as zsh is not installed
}

mkdir -p $HOME/.config
setup_zsh_symlinks

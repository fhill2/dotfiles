# post_install
# post installation script after the package list has been installed...

# post install for sway otherwise sway shows Permission Denied errors on launch...
# This may not be necessary, try only installing seatd to see if it fixes the perm errors
# sudo apt install seatd
sudo useradd seat
sudo usermod -a -G seat $USER
sudo systemctl enable seatd.service

# Currently not working on debian...
# PAM Authentication Failure
sudo chsh -s $(which zsh) $USER

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
	ln -s ~/dot/config/profile_linux ~/.profile
	# unnecessary to source ~/.zshrc at this point
	# as zsh is not installed
}

mkdir -p $HOME/.config
setup_zsh_symlinks

# https://gitlab.freedesktop.org/mesa/drm/-/issues/52#note_619180
# amd_gpu_initialized_failed error
# solution is to restart after the seat management daemon has been installed
echo "A Reboot is needed in order for sway to start"

mkdir -p $HOME/Desktop

# install google chrome
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo apt install ./google-chrome-stable_current_amd64.deb

# Debian did not correctly set the locale on installation
# Shown when installing packages with apt
# https://serverfault.com/a/362910
# https://forums.debian.net/viewtopic.php?t=146922
echo 'LANG=en_GB.UTF-8' | sudo tee /etc/default/locale
sudo /usr/sbin/locale-gen # have to run locale-gen as root

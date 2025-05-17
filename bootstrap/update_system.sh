# Steps to updating a Debian Machine
# Install packages
./install_packages.sh
sudo apt-get update
rustup update

cd ~/apps/neovim &&
	sudo make install

echo "Now enter Neovim and :Lazy then U"

# Note when creating custom scripts to software installed by homebrew

Do not use /opt/homebrew/bin/app
instead use "$(brew --prefix)/bin/app"
Intel Homebrew = /usr/local
ARM Homebrew = /opt/homebrew

System directories
~/.local/bin - This is a directory symlink to bin folder of dotfiles, ~/dot/bin
/usr/local/bin - all app repos that I am compiling from source are cloned into:
~/.apps, and their binaries symlinked to /usr/local/bin. Why /usr/local/bin. Because its allready on $PATH on linux & osx, and is not protected by SIP unlike /usr/bin on OSX. Im also using ~/.local/bin for user scripts.

# What about xcode command line tools?

all packages from xcode CLI install into /Library/Developer/CommandLineTools
notable packages installed are:
python, git

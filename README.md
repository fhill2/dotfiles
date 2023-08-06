To install:

```
bash <(curl -s https://raw.githubusercontent.com/fhill2/dotfiles/master/bootstrap/bootstrap.sh)
./bootstrap.sh
```

# Why ./bootstrap and ./setup?
/config/ - holds configuration files for apps.
/installers/ - files related to the installation of the apps.
./bootstrap -> once per install setup functions in here, and tools/requirements/setup for installers. 
bin/installer.sh -> once bootstrap.sh symlinks ~/dot/bin to ~/.local/bin, _installer.sh is on PATH.


# Why not git clone?
Because on a fresh install of osx, git is not installed by default.
On linux, it may be depending on a few factors.
on linux, we could `pacman -S git` and git clone https://github.com/fhill2/dotfiles
on osx, git requires homebrew to be installed first so git can managed by it. Therefore, downloading the git repo with curl, and running bootstrap to install homebrew allows unattended installation.






System directories
~/.local/bin - This is a directory symlink to bin folder of dotfiles, ~/dot/bin
/usr/local/bin - all app repos that I am compiling from source are cloned into ~/.apps, and their binaries symlinked to /usr/local/bin. Why /usr/local/bin. Because its allready on $PATH on linux & osx, and is not protected by SIP unlike /usr/bin on OSX. Im also using ~/.local/bin for user scripts.





Benefits of cross platform installer scripts:
- code is more readable, and can be maintained together

Cons:
- its slow, more invocations to package manager (although python installers solved this)

# why symlink installer.sh to /usr/local/bin?
as certain functions in the installer need to be accessed via root
eg sudo symlink_dotfile is necessary


# Why symlink ~/.local/bin -> ~/dot/bin?
~/.local/bin is not included on $PATH on osx or linux by default, so it makes no difference if ~/dot/bin is added to $PATH or ~/.local/bin is added to $PATH.


# Why not use homebrew on OSX and Linux?
There can be package conflicts with linux's system package manager, and homebrew.

# Why not install all language specifc packages using homebrew?
This is an option, I am used to working on Linux and installing these packages using each language's package managers.

# What about xcode command line tools?
 all packages from xcode CLI install into /Library/Developer/CommandLineTools
 notable packages installed are:
 python, git


/linux/ or /osx/ - holds configuration files for linux or osx specific software.
/shared/ - holds configuration files for cross platform software.
/install/ - files related to the installation of these dotfiles.
install.sh - 



Benefits of cross platform installer scripts:
- code is more readable, and can be maintained together

Cons:
- its slow, more invocations to package manager (although python installers solved this)



# Why not use homebrew on OSX and Linux?
There can be package conflicts with linux's system package manager, and homebrew.

# Why not install all language specifc packages using homebrew?
This is an option, I am used to working on Linux and installing these packages using each language's package managers.
# base install - leave alone otherwise aconfmgr will uninstall minimal packages
AddPackage autoconf # A GNU tool for automatically configuring source code
AddPackage automake # A GNU tool for automatically creating Makefiles
AddPackage base # Minimal package set to define a basic Arch Linux installation
AddPackage binutils # A set of programs to assemble and manipulate binary and object files
AddPackage bison # The GNU general-purpose parser generator
AddPackage efibootmgr # Linux user-space application to modify the EFI Boot Manager
AddPackage expect # A tool for automating interactive applications
AddPackage fakeroot # Tool for simulating superuser privileges
AddPackage flex # A tool for generating text-scanning programs
AddPackage gcc # The GNU Compiler Collection - C and C++ frontends
AddPackage git # the fast distributed version control system
AddPackage groff # GNU troff text-formatting system
AddPackage grub # GNU GRand Unified Bootloader (2)
AddPackage libtool # A generic library support script
AddPackage linux # The Linux kernel and modules
AddPackage linux-firmware # Firmware files for Linux
AddPackage linux-headers # Headers and scripts for building modules for the Linux kernel
AddPackage m4 # The GNU macro processor
AddPackage make # GNU make utility to maintain groups of programs
AddPackage sudo # Give certain users the ability to run some commands as root
AddPackage texinfo # GNU documentation system for on-line information and printed output
AddPackage which # A utility to show the full path of commands
AddPackage zsh # A very advanced and programmable command interpreter (shell) for UNIX

### end necessary packages

AddPackage nfs-utils # Support programs for Network File Systems
AddPackage pacutils # Helper tools for libalpm
AddPackage patch # A utility to apply patch files to original sources
AddPackage pkgconf # Package compiler and linker metadata toolkit


AddPackage alacritty # A cross-platform, GPU-accelerated terminal emulator
AddPackage arch-install-scripts # Scripts to aid in installing Arch Linux
AddPackage arp-scan # A tool that uses ARP to discover and fingerprint IP hosts on the local network
AddPackage bash-language-server # Bash language server implementation based on Tree Sitter and its grammar for Bash
AddPackage bat # Cat clone with syntax highlighting and git integration
AddPackage bind # A complete, highly portable implementation of the DNS protocol
AddPackage bottom # A graphical process/system monitor
AddPackage btrfs-progs # Btrfs filesystem utilities
AddPackage cmake # A cross-platform open-source make system
AddPackage csound # A programming language for sound rendering and signal processing.
AddPackage darkhttpd # A small and secure static webserver
AddPackage dhcp # A DHCP server, client, and relay agent
AddPackage dialog # A tool to display dialog boxes from shell scripts
AddPackage discord # All-in-one voice and text chat for gamers that's free and secure.
AddPackage docker # Pack, ship and run any application as a lightweight container
AddPackage dosfstools # DOS filesystem utilities
AddPackage dunst # Customizable and lightweight notification-daemon
AddPackage element # A modular LV2/VST3 audio plugin host
AddPackage element-desktop # Glossy Matrix collaboration client — desktop version.
AddPackage evtest # Input device event monitor and query tool
AddPackage fd # Simple, fast and user-friendly alternative to find
AddPackage firefox # Standalone web browser from mozilla.org
AddPackage fio # Scriptable I/O tool for storage benchmarks and drive testing
AddPackage freerdp # Free implementation of the Remote Desktop Protocol (RDP)
AddPackage fzf # Command-line fuzzy finder
AddPackage ghostscript # An interpreter for the PostScript language
AddPackage gnome-control-center # GNOME's main interface to configure various aspects of the desktop
AddPackage gparted # A Partition Magic clone, frontend to GNU Parted
AddPackage hexchat # A popular and easy to use graphical IRC (chat) client
AddPackage hwloc # Portable Hardware Locality is a portable abstraction of hierarchical architectures
AddPackage inetutils # A collection of common network programs
AddPackage kate # Advanced Text Editor
AddPackage kdiskmark # HDD and SSD benchmark tool with a very friendly graphical user interface
AddPackage kitty # A modern, hackable, featureful, OpenGL-based terminal emulator
AddPackage libreoffice-still # LibreOffice maintenance branch

AddPackage lsof # Lists open files for running Unix processes
AddPackage lua51 # Powerful lightweight programming language designed for extending applications
AddPackage luarocks # Deployment and management system for Lua modules
AddPackage maim # Utility to take a screenshot using imlib2
AddPackage man-db # A utility for reading man pages
AddPackage mtools # A collection of utilities to access MS-DOS disks
AddPackage nano # Pico editor clone with enhancements
AddPackage nautilus # Default file manager for GNOME

AddPackage networkmanager # Network connection manager and user applications
AddPackage nmap # Utility for network discovery and security auditing
AddPackage npm # A package manager for javascript
AddPackage ntfs-3g # NTFS filesystem driver and utilities
AddPackage os-prober # Utility to detect other OSes on a set of drives
AddPackage pcmanfm # Extremely fast and lightweight file manager
AddPackage pyright # Type checker for the Python language
AddPackage python-evdev # Python bindings for the Linux input subsystem
AddPackage openbsd-netcat # TCP/IP swiss army knife. OpenBSD variant.
AddPackage python-pip # The PyPA recommended tool for installing Python packages
AddPackage python-pywinrm # Python library for Windows Remote Management
AddPackage qbittorrent # An advanced BitTorrent client programmed in C++, based on Qt toolkit and libtorrent-rasterbar
AddPackage qtile # A full-featured, pure-Python tiling window manager
AddPackage rebuild-detector # Detects which packages need to be rebuilt
AddPackage reflector # A Python 3 module and script to retrieve and filter the latest Pacman mirror list.
AddPackage remmina # remote desktop client written in GTK+
AddPackage ripgrep # A search tool that combines the usability of ag with the raw speed of grep
AddPackage rofi # A window switcher, application launcher and dmenu replacement
AddPackage rsync # A fast and versatile file copying tool for remote and local files
AddPackage rt-tests # A collection of latency testing tools for the linux(-rt) kernel
AddPackage ruby # An object-oriented language for quick and easy programming
AddPackage ruby-rake # Make-like build tool implemented in Ruby
AddPackage sd # Intuitive find & replace
AddPackage subversion # A Modern Concurrent Version Control System
AddPackage swtpm # Libtpms-based TPM emulator with socket, character device, and Linux CUSE interface
AddPackage syncthing # Open Source Continuous Replication / Cluster Synchronization Thing
AddPackage sysstat # a collection of performance monitoring tools (iostat,isag,mpstat,pidstat,sadf,sar)
AddPackage system-config-printer # A CUPS printer configuration tool and status applet
AddPackage tcpdump # Powerful command-line packet analyzer
AddPackage tigervnc # Suite of VNC servers and clients. Based on the VNC 4 branch of TightVNC.
AddPackage traceroute # Tracks the route taken by packets over an IP network
AddPackage usbutils # A collection of USB tools to query connected USB devices
AddPackage vifm # A file manager with curses interface, which provides Vi[m]-like environment
AddPackage virt-manager # Desktop user interface for managing virtual machines
AddPackage vlc # Multi-platform MPEG, VCD/DVD, and DivX player
AddPackage vscode-css-languageserver # CSS/LESS/SCSS language server
AddPackage vscode-html-languageserver # HTML language server
AddPackage vscode-json-languageserver # JSON language server
AddPackage wget # Network utility to retrieve files from the Web
AddPackage wmctrl # Control your EWMH compliant window manager from command line
AddPackage xcape # Configure modifier keys to act as other keys when pressed and released on their own
AddPackage xclip # Command line interface to the X11 clipboard
AddPackage xdotool # Command-line X11 automation tool
AddPackage xorg-server # Xorg X server
AddPackage xorg-xdpyinfo # Display information utility for X
AddPackage xorg-xev # Print contents of X events
AddPackage xorg-xinit # X.Org initialisation program
AddPackage xorg-xrandr # Primitive command line interface to RandR extension
AddPackage xplr # A hackable, minimal, fast TUI file explorer
AddPackage yaml-language-server # YAML Language Server
AddPackage zoxide # A smarter cd command for your terminal
AddPackage netctl # Profile based systemd network management




AddPackage libxpresent # X Present Extension library
AddPackage --foreign lua-language-server-git # Lua Language Server coded by Lua

AddPackage --foreign brlaser # CUPS driver for the Brother DCP-7065DN
AddPackage --foreign brother-dcp1610w # LPR and CUPS driver for the Brother DCP-1610W and DCP-1612W printers
AddPackage --foreign ddccontrol-git # Control your monitor by software using the DDC/CI protocol.
AddPackage --foreign dockerfile-language-server # Language server for Dockerfiles
AddPackage --foreign google-chrome-dev # The popular and trusted web browser by Google (Dev Channel)
AddPackage --foreign hfsprogs # User space utils for create and check Apple HFS/HFS+ filesystem
AddPackage htop # Interactive process viewer
AddPackage --foreign nodejs-live-server # A simple development HTTP server with live reload capability
AddPackage obsidian # Obsidian is a powerful knowledge base that works on top of a local folder of plain text Markdown files
AddPackage --foreign python39 # Major release 3.9 of the Python high-level programming language
AddPackage --foreign rnix-lsp-git # A language server for Nix
AddPackage --foreign slack-desktop # Slack Desktop (Beta) for Linux
AddPackage --foreign snap-pac-grub # Pacman hook to update GRUB entries for grub-btrfs after snap-pac made snapshots



AddPackage --foreign snapper-gui-git # Gui for snapper, a tool of managing snapshots of Btrfs subvolumes and LVM volumes
AddPackage spice-protocol # Headers for SPICE protocol
AddPackage stylua # Code formatter for Lua

AddPackage --foreign neovim-git # Fork of Vim aiming to improve user experience, plugins, and GUIs.
AddPackage --foreign stylua # Code formatter for Lua
AddPackage --foreign typescript-language-server # Language Server Protocol (LSP) implementation for TypeScript using tsserver
AddPackage --foreign vim-language-server # VimScript language server
AddPackage --foreign xmousepasteblock-git # Userspace tool to disable middle mouse button paste in Xorg
AddPackage --foreign zplug # A next-generation plugin manager for zsh


# Wed Jan 26 06:50:06 UTC 2022 - Unknown foreign packages


AddPackage --foreign neovim-sniprun # Independently run snippets of code
AddPackage --foreign aconfmgr-git # A configuration manager for Arch Linux
AddPackage --foreign bitwig-studio # Digital audio workstation for music production, remixing and live performance
AddPackage --foreign btdu-bin # sampling disk usage profiler for btrfs
AddPackage --foreign btrfs-list-git # A wrapper to btrfs-progs to show a nice overview of your btrfs subvolumes and snapshots, a la 'zfs list'
AddPackage --foreign downgrade # Bash script for downgrading one or more packages to a version in your cache or the A.L.A.
AddPackage --foreign ipmitool-git # Tool for controlling IPMI-enabled systems
AddPackage --foreign ipmiview # Supermicro IPMI tool
AddPackage --foreign pet-bin # Simple command-line snippet manager, written in Go.
AddPackage --foreign qimgv # Qt5 image viewer with experimental webm playback
AddPackage --foreign snapper-rollback # Script to rollback snapper snapshots as described here https://wiki.archlinux.org/index.php/Snapper#Suggested_filesystem_layout
AddPackage --foreign the-way-git # A command line code snippets manager
AddPackage --foreign unetbootin # Create bootable Live USB drives
AddPackage --foreign yay # Yet another yogurt. Pacman wrapper and AUR helper written in go.





# Fri Apr 15 12:18:22 AM UTC 2022 - Unknown packages


AddPackage bat-extras # Bash scripts that integrate bat with various command line tools
AddPackage clang # C language family frontend for LLVM
AddPackage composer # Dependency Manager for PHP
AddPackage dolphin # KDE File Manager
AddPackage github-cli # The GitHub CLI
AddPackage gnome-keyring # Stores passwords and encryption keys
AddPackage go # Core compiler tools for the Go programming language
AddPackage go-yq # Portable command-line YAML processor
AddPackage kleopatra # Certificate Manager and Unified Crypto GUI
AddPackage lesspipe # an input filter for the pager less
AddPackage mdcat # Sophisticated Markdown rendering for the terminal
AddPackage nemo # Cinnamon file manager (Nautilus fork)
AddPackage nemo-fileroller # File archiver extension for Nemo
AddPackage nemo-preview # Quick file previewer for Nemo
AddPackage pandoc # Conversion between markup formats
AddPackage pass # Stores, retrieves, generates, and synchronizes passwords securely
AddPackage perl-rename # Renames multiple files using Perl regular expressions.
AddPackage php7 # A general-purpose scripting language that is especially suited to web development
AddPackage qt5ct # Qt5 Configuration Utility
AddPackage ripgrep-all # rga: ripgrep, but also search in PDFs, E-Books, Office documents, zip, tar.gz, etc.
AddPackage screen # Full-screen window manager that multiplexes a physical terminal
AddPackage seahorse # GNOME application for managing PGP keys.
AddPackage sushi # A quick previewer for Nautilus
AddPackage the_silver_searcher # Code searching tool similar to Ack, but faster
AddPackage tmux # A terminal multiplexer
AddPackage trash-cli # Command line trashcan (recycle bin) interface
AddPackage yarn # Fast, reliable, and secure dependency management


# Thu Feb  3 19:31:22 UTC 2022 - Unknown foreign packages
AddPackage --foreign inxi # Full featured CLI system information tool

# Fri Apr 15 12:18:23 AM UTC 2022 - Unknown foreign packages


AddPackage --foreign anydesk-bin # The Fast Remote Desktop Application
AddPackage --foreign cpupower-gui-git # A GUI utility to set CPU frequency limits
AddPackage --foreign ghorg # allows you to quickly clone all of an orgs, or users repos into a single directory.
AddPackage --foreign git-credential-manager-core-bin # Secure, cross-platform Git credential storage with authentication to GitHub, Azure Repos, and other popular Git hosting services.
AddPackage --foreign hyperfine-git # A command-line benchmarking tool
AddPackage --foreign krusader-git # Advanced twin panel file manager for KDE. (GIT version)
AddPackage --foreign lssecret-git # utility to list all secret items in a secret service using libsecret
AddPackage --foreign nvimpager-git # Use nvim as a pager to view manpages, diffs, etc with nvim's syntax highlighting
AddPackage --foreign paru # Feature packed AUR helper
AddPackage --foreign polo-bin # A modern, light-weight GTK file manager for Linux, currently in beta (.deb binary version)
AddPackage --foreign ripasso-cursive # A password manager that uses the file format of the standard unix password manager 'pass', implemented in rust.
AddPackage --foreign tmux-plugin-manager # tpm - Tmux Plugin Manager
AddPackage --foreign vscode-langservers-extracted # Language servers extracted from VSCode.


AddPackage --foreign dotbot


AddPackage arandr # Provide a simple visual front end for XRandR 1.2.
AddPackage mesa-utils # essential Mesa utilities


# Sun 17 Apr 20:51:45 BST 2022 - Unknown foreign packages


AddPackage --foreign nvim-packer-git # A use-package inspired plugin manager for Neovim.



#!/bin/sh
# my osx defaults


# JUN 2023 Still to automate:
# Sound > Alert Volume to 0. This is because of key repeat + karabiner. key repeat triggers beep on tab_as_hyper.

# Keyboard Shortcuts to disable:
# Input Sources ----- IMPORTANT - otherwise C-Space does not get to terminal

# this defaults files is based on:
# https://github.com/mathiasbynens/dotfiles/blob/main/.macos



# Other defaults files:
# https://github.com/kdeldycke/dotfiles/blob/74e8590028680356e37d5ba413049ec56fe764e4/macos-config.sh#L1
# https://gist.github.com/brandonb927/3195465
# https://github.com/dbalatero/dotfiles/blob/master/osx
# https://github.com/mathiasbynens/dotfiles/blob/master/.macos
# https://snippets.cacher.io/snippet/9e0e446fe26b04fb6196
# https://github.com/joeyhoer/starter/tree/master/system
# https://gist.github.com/Moscarda/1abb40b39c6636d4f022cbfbd90cf890
# macos-defaults.com
# www.defaults-write.com/
# ======================================

###############################################################################
# Requirements                                                                    #
###############################################################################

# Requirements (not bootstrapped)
# defaults relies on HOSTNAME being set beforehand, maybe with strap?
# brew install --cask monitorcontrol # editing external monitor display settings using CLI
# brew install smudge/smudge/nightlight # editing OSX Night Shift using CLI

###############################################################################
# TODO/ TO ADD                                                                     #
###############################################################################



# Finder > view options > icon size > smallest
# Finder > view options > text size > 12
# Finder > settings > favorites > all checked (check home)
# Finder > settings > new finder windows shows > f1
# finder > sidebar > harddisks from - to tick <- to show all
# finder > cmd+j > calculate all file sizes
# finder > view options > use as defaults to apply calculate all sizes to every I enter
# https://community.jamf.com/t5/jamf-pro/finder-settings-script/td-p/186534


# how to programatically add apps installed from homebrew to accessability?
# -> this cannot be done (easily) on ventura as tccutil does not work
# turn off all hot corners. wait until ive gone through all other default writes.

# how to disable window minimize animation?

# chrome modifications
# allow from websites I visit 
# disable autoplay youtube videos

###############################################################################
# Plist and preferences                                                       #
###############################################################################
# There is a couple of plist editing tools:
#
#  * defaults
#    Triggers update notification update to running process, but usage is
#    tedious.
#
#  * /usr/libexec/PlistBuddy
#    Great for big update, can create non-existing files.
#
#  * plutil
#    Can manipulate arrays and dictionaries with key paths.
#
# Sources:
#   * https://scriptingosx.com/2016/11/editing-property-lists/
#   * https://scriptingosx.com/2018/02/defaults-the-plist-killer/
#   * https://apps.tempel.org/PrefsEditor/index.php
#
# Some of these changes still require a logout/restart to take effect.

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'


###############################################################################
# Networking / Sharing                                                             #
###############################################################################


# Set Network Names
# Transform '  |   "model" = <"MacBookAir8,1">' to 'MBA'
#COMPUTER_MODEL_SHORTHAND=$(ioreg -c IOPlatformExpertDevice -d 2 -r | grep '"model" =' | python -c "print(''.join([c for c in input() if c.isupper()]))")
#COMPUTER_NAME="$(whoami)-${COMPUTER_MODEL_SHORTHAND}"
# Set computer name (as done via System Preferences → Sharing)
sudo scutil --set ComputerName "${HOST}"
# sudo scutil --set HostName "${COMPUTER_NAME}"
sudo scutil --set LocalHostName "${HOST}"

# Smb Sharing
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "${HOST}"

# Turn on smb file sharing
sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.smbd.plist
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server.plist EnabledServices -array disk

# https://apple.stackexchange.com/a/371105
# Add folder to Sharing tab
sudo sharing -a /Users/Shared

# Enable remote login
# Remote login is already Off by default on Ventura. We can ignore it for now.
#sudo systemsetup -setremotelogin on

###############################################################################
# Login / Launch                                                              #
###############################################################################

# Add .login script to login items (check for exist before)
gparent=`dirname $(realpath $(dirname "$0"))`
loginItemPath="$gparent/.login"
loginItemName=".login"
loginItemHidden=false
existingLoginItem=$(osascript -e "tell application \"System Events\" to get the name of every login item" | grep "$loginItemName")
if [[ -z $existingLoginItem ]]; then
    # Add the login item
    osascript -e "tell application \"System Events\" to make login item at end with properties {path:\"$loginItemPath\", name:\"$loginItemName\", hidden:$loginItemHidden}"
    echo "Login item added successfully."
else
    echo "Login item already exists."
fi

# AFP -User & Groups > Guest User > Allow guests to log in to this computer
sudo defaults write /Library/Preferences/com.apple.AppleFileServer guestAccess -bool false

# User & Groups > Guest User > Allow guests users to connect to shared folders
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server AllowGuestAccess -bool true

###############################################################################
# General UI/UX                                                               #
###############################################################################

# Enable do not disturb https://apple.stackexchange.com/a/303400
# defaults -currentHost write ~/Library/Preferences/ByHost/com.apple.notificationcenterui doNotDisturb -boolean true
# defaults -currentHost write ~/Library/Preferences/ByHost/com.apple.notificationcenterui doNotDisturbDate -date "`date -u +\"%Y-%m-%d %H:%M:%S +0000\"`"
# killall NotificationCenter


# Disable windows expose https://apple.stackexchange.com/a/335151
# Turns off separate desktop spaces
# when you drag a window all the way up, hold for *a second or two* and it opens Mission Control
# System Prefs > Mission Control > Displays Have Separate Spaces
defaults write com.apple.dock mcx-expose-disabled -bool TRUE


# Remove default content
sudo rm -rf "${HOME}/Public/Drop Box"
rm -rf "${HOME}/Public/.com.apple.timemachine.supported"
rm -f "${HOME}/Desktop/SamsungPortableSSD.app"

# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "

# ENABLE: ctrl+option+cmd + mouse drag any part of a window to move it.
defaults write com.apple.universalaccess NSWindowShouldDragOnGesture -string "YES"

# Enable dark mode
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"
# defaults write NSGlobalDomain AppleInterfaceStyleSwitchesAutomatically -bool true




# Set sidebar icon size to medium
defaults write NSGlobalDomain NSTableViewDefaultSizeMode -int 2

# Always show scrollbars
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"
# Possible values: `WhenScrolling`, `Automatic` and `Always`

# Disable the over-the-top focus ring animation
# this is the black circle animation when clicking on certain parts of the UI (like browser url bar)
defaults write NSGlobalDomain NSUseAnimatedFocusRing -bool false

# Adjust toolbar title rollover delay (0 is off)
# https://macos-defaults.com/finder/nstoolbartitleviewrolloverdelay.html
defaults write NSGlobalDomain NSToolbarTitleViewRolloverDelay -float 0



# Increase window resize speed for Cocoa applications
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

# Ask to keep changes when closing documents
defaults write NSGlobalDomain NSCloseAlwaysConfirmsChanges -bool true

# DISABLE: Menu Bar > Apple > Recent Items > Documents, Apps, Servers.
osascript << EOF
  tell application "System Events"
    tell appearance preferences
      set recent documents limit to 5
      set recent applications limit to 5
      set recent servers limit to 5
    end tell
  end tell
EOF

# Sometimes it can happen when saving a document that you have to click first on the triangle next to the Location field to open the expanded save window.
# https://www.defaults-write.com/expand-save-panel-default/
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default - more options in the print popup when printing a document
# https://eshop.macsales.com/blog/44582-quick-tip-displaying-the-macos-expanded-print-details-dialog-by-default/
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false


# Keep all windows open from previous session.
defaults write com.apple.systempreferences NSQuitAlwaysKeepsWindows -bool true

# Disable automatic termination of inactive apps
defaults write NSGlobalDomain NSDisableAutomaticTermination -bool true


# Disable the crash reporter that pops up when an app crashes
# https://developer.apple.com/forums/thread/702380
defaults write com.apple.CrashReporter DialogType -string "none"


# Set Help Viewer windows to non-floating mode
defaults write com.apple.helpviewer DevMode -bool true

# Reveal IP address, hostname, OS version, etc. when clicking the clock
# in the login window
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo -string "HostName"

# Restart automatically if the computer freezes
sudo systemsetup -setrestartfreeze on

# Disable automatic capitalization as it’s annoying when typing code
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

# Disable smart dashes as they’re annoying when typing code
# smart dashes -> turns 2 single dashes into 1 double space dash
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable automatic period substitution as it’s annoying when typing code
# https://stackoverflow.com/questions/42566449/avoid-auto-period-character-after-quick-type-space-in-sublime-text-3
# hitting space fast twice will insert a period.
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# Disable smart quotes as they’re annoying when typing code
# https://macmost.com/using-smart-quotes.html
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

# DISABLE: UI sound effects
# https://superuser.com/questions/332940/disable-sound-effects-in-osx-lion
# hitting delete at Terminal triggers a sound effect
defaults write -globalDomain "com.apple.sound.uiaudio.enabled" -int 0

# Play feedback when volume is changed
defaults write -globalDomain "com.apple.sound.beep.feedback" -int 0



##############################################################################
# Menubar                                                                    #
##############################################################################



# Enable input menu in menu bar.
defaults write com.apple.TextInputMenu visible -bool true
defaults write com.apple.TextInputMenuAgent "NSStatusItem Visible Item-0" -bool true

# Menu bar: hide the User and Battery icons
# defaults -currentHost write dontAutoLoad -array \
#         "/System/Library/CoreServices/Menu Extras/User.menu"
# defaults write com.apple.systemuiserver menuExtras -array \
#         "/System/Library/CoreServices/Menu Extras/TimeMachine.menu" \
#         "/System/Library/CoreServices/Menu Extras/AirPort.menu" \
#         "/System/Library/CoreServices/Menu Extras/Bluetooth.menu" \
#         "/System/Library/CoreServices/Menu Extras/TextInput.menu" \
#         "/System/Library/CoreServices/Menu Extras/Volume.menu" \
#         "/System/Library/CoreServices/Menu Extras/Clock.menu"




##############################################################################
# Security                                                                   #
##############################################################################
# Also see: https://github.com/drduh/macOS-Security-and-Privacy-Guide
# https://benchmarks.cisecurity.org/tools2/osx/CIS_Apple_OSX_10.12_Benchmark_v1.0.0.pdf

# "Disabling OS X Gate Keeper"
# "(You'll be able to install any app you want from here on, not just Mac App Store apps)"
sudo spctl --master-disable
sudo defaults write /var/db/SystemPolicy-prefs.plist enabled -string no
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Disable IR remote control
# Infrared Receiver - you can use your apple remote to control audio playback on macbook
sudo defaults write /Library/Preferences/com.apple.driver.AppleIRController DeviceEnabled -bool false

# Disable remote apple events
# With remote Apple events turned on, an AppleScript program running on another Mac can interact with your Mac.
sudo systemsetup -setremoteappleevents off



# Disable wake-on modem
# XXX setwakeonmodem returns "Wake On Modem: Not supported on this machine." for now.
#sudo systemsetup -setwakeonmodem off
sudo pmset -a ring 0

# Disable wake-on LAN
# Wake-on-LAN (WoL) is an Ethernet or Token ring computer networking standard that allows a computer to be turned on or awakened by a network message. The message is usually sent by a program executed on another computer on the same local area network.
sudo systemsetup -setwakeonnetworkaccess off
sudo pmset -a womp 0

# Display login window as name and password
sudo defaults write /Library/Preferences/com.apple.loginwindow SHOWFULLNAME -bool true

# Do not show password hints
sudo defaults write /Library/Preferences/com.apple.loginwindow RetriesUntilHint -int 0

# Disable guest account login
sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool false

# Disable automatic login
sudo defaults delete /Library/Preferences/com.apple.loginwindow autoLoginUser || true

# A lost machine might be lucky and stumble upon a Good Samaritan.
sudo defaults write /Library/Preferences/com.apple.loginwindow LoginwindowText \
    "Found this computer? Please contact me at freddiehill000@gmail.com ."

# Automatically lock the login keychain for inactivity after 6 hours.
security set-keychain-settings -t 21600 -l "${HOME}/Library/Keychains/login.keychain"


# Enable secure virtual memory
# Select “Use secure virtual memory” to erase any information from random-access memory written to the hard disk by virtual memory.
sudo defaults write /Library/Preferences/com.apple.virtualMemory UseEncryptedSwap -bool true

# Disable Bonjour multicast advertisements
# When Disabled:
# You will not be able to see other devices on the network that are using Bonjour.
# Other devices will not be able to see your computer.
# You will not be able to use Bonjour to connect to shared printers, file shares, and other services.
# Some applications may not work properly.
sudo defaults write /Library/Preferences/com.apple.mDNSResponder.plist NoMulticastAdvertisements -bool true

# Show location icon in menu bar when System Services request your location.
sudo defaults write /Library/Preferences/com.apple.locationmenu.plist ShowSystemServices -bool true

###############################################################################
# Trackpad,                #
###############################################################################
# Trackpad: speed
defaults write -g com.apple.trackpad.scaling 3
defaults write NSGlobalDomain com.apple.trackpad.scaling -int 3

# Trackpad: enable tap to click for this user and for the login screen
#defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
#defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
#defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
#defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Trackpad: right-click by tapping with two fingers
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

# Trackpad: swipe between pages with three fingers
defaults write NSGlobalDomain AppleEnableSwipeNavigateWithScrolls -bool true
defaults -currentHost write NSGlobalDomain com.apple.trackpad.threeFingerHorizSwipeGesture -int 1
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerHorizSwipeGesture -int 1


# Trackpad: map bottom right corner to right-click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults -currentHost write NSGlobalDomain com.apple.trackpad.trackpadCornerClickBehavior -int 1
defaults -currentHost write NSGlobalDomain com.apple.trackpad.enableSecondaryClick -bool true

###############################################################################
# Keyboard
###############################################################################

# Enable full keyboard access for all controls
# (e.g. enable Tab in modal dialogs)
# https://support.apple.com/en-gb/guide/mac-help/mchlc06d1059/mac#:~:text=Turn%20on%20Full%20Keyboard%20Access,turn%20on%20Full%20Keyboard%20Access.
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Set a blazingly fast keyboard repeat rate
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 15

###############################################################################
# Mouse
###############################################################################

# Set mouse and scrolling speed.
defaults write NSGlobalDomain com.apple.mouse.scaling -int 2.5
defaults write NSGlobalDomain com.apple.scrollwheel.scaling -float 0.6875

# Mouse: disable acceleration
# defaults write .GlobalPreferences com.apple.mouse.scaling -1


# Disable “natural” (Lion-style) scrolling
# natural -> swiping down scrolls page down
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# Application switcher follows monitor with last hidden dock.
defaults write com.apple.Dock appswitcher-all-displays -bool true


# Only show opened apps in Dock.
# https://macos-defaults.com/dock/static-only.html
defaults write com.apple.dock "static-only" -bool "true" 

# Dock position - bottom
# https://macos-defaults.com/dock/orientation.html
defaults write com.apple.dock "orientation" -string "bottom"






###############################################################################
# Bluetooth
###############################################################################

# Increase sound quality for Bluetooth headphones/headsets.
# Sources:
#     https://www.reddit.com/r/apple/comments/5rfdj6/pro_tip_significantly_improve_bluetooth_audio/
#     https://apple.stackexchange.com/questions/40259/bluetooth-audio-problems-on-a-macbook


# for bitpool_param (
#     "Negotiated Bitpool"
#     "Negotiated Bitpool Max"
#     "Negotiated Bitpool Min"
#     "Apple Bitpool Max (editable)"
#     "Apple Bitpool Min (editable)"
#     "Apple Initial Bitpool (editable)"
#     "Apple Initial Bitpool Min (editable)"
# ); do

defaults write com.apple.BluetoothAudioAgent "Negotiated Bitpool" -int 80
defaults write com.apple.BluetoothAudioAgent "Negotiated Bitpool Max" -int 80
defaults write com.apple.BluetoothAudioAgent "Negotiated Bitpool Min" -int 80
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Max (editable)" -int 80
defaults write com.apple.BluetoothAudioAgent "Apple Bitpool Min (editable)" -int 80
defaults write com.apple.BluetoothAudioAgent "Apple Initial Bitpool (editable)" -int 80
defaults write com.apple.BluetoothAudioAgent "Apple Initial Bitpool Min (editable)" -int 80



###############################################################################
# Bluetooth
###############################################################################

# Turn Bluetooth off completely
# sudo defaults write /Library/Preferences/com.apple.Bluetooth ControllerPowerState -int 0

# Use control+mouse-scroll or control+trackpad-scroll to zoom
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144
# Follow the keyboard focus while zoomed in
defaults write com.apple.universalaccess closeViewZoomFollowsFocus -bool true


###############################################################################
# Time / Date
###############################################################################

# Location Services is needed to autmatically set the time
sudo defaults write /var/db/locationd/Library/Preferences/ByHost/com.apple.locationd LocationServicesEnabled -bool true

# Set the timezone; see `sudo systemsetup -listtimezones` for other values
#sudo systemsetup -settimezone "Europe/Paris" > /dev/null
#sudo systemsetup -setnetworktimeserver "time.euro.apple.com"
#sudo systemsetup -setusingnetworktime on

# Do not set timezone automatticaly depending on location.
# sudo defaults write /Library/Preferences/com.apple.timezone.auto.plist Active -bool false

# Enable 24 hour time.
defaults write com.apple.menuextra.clock DateFormat -string "EEE d MMM HH:mm"

###############################################################################
# Language
###############################################################################

# Set language and text formats
# Note: if you’re in the US, replace `EUR` with `USD`, `Centimeters` with
# `Inches`, `en_GB` with `en_US`, and `true` with `false`.
defaults write NSGlobalDomain AppleLanguages -array "en"
defaults write NSGlobalDomain AppleLocale -string "en_GB@currency=EUR"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
defaults write NSGlobalDomain AppleMetricUnits -bool true

# Show language menu in the top right corner of the boot screen
sudo defaults write /Library/Preferences/com.apple.loginwindow showInputMenu -bool true


###############################################################################
# Energy saving                                                               #
###############################################################################

# Disable Resume system-wide so a restart is a true restart
defaults write NSGlobalDomain NSQuitAlwaysKeepsWindows -bool false

# Enable waking up from sleep mode when you open the laptop lid
sudo pmset -a lidwake 1

# Automatic restart on power loss
sudo pmset -a autorestart 1

# Restart automatically if the computer freezes
sudo systemsetup -setrestartfreeze on

# Sets display sleep to 10 minutes
sudo pmset -a displaysleep 10

# Do not allow machine to sleep on charger
sudo pmset -c sleep 0

# Set machine sleep to 5 minutes on battery
sudo pmset -b sleep 5

# Set standby delay to default 1 hour
# See: https://www.ewal.net/2012/09/09/slow-wake-for-macbook-pro-retina/
sudo pmset -a standbydelay 3600

#sudo pmset sleep 0  # minutes of inactivity before the computer goes to sleep.
#sudo pmset displaysleep 0  # minutes of inactivity before the display sleeps.
# sudo pmset disksleep 0  # minutes of inactivity before the disk goes to sleep

# Never go into computer sleep mode
#sudo systemsetup -setcomputersleep Off > /dev/null

# Hibernation mode
# 0: Disable hibernation (speeds up entering sleep mode)
# 3: Copy RAM to disk so the system state can still be restored in case of a
#    power failure.
sudo pmset -a hibernatemode 3
# sudo pmset autopoweroff 0  # This is a form of hibernation

# Remove the sleep image file to save disk space
#sudo rm /private/var/vm/sleepimage
# Create a zero-byte file instead…
#sudo touch /private/var/vm/sleepimage
# …and make sure it can’t be rewritten
#sudo chflags uchg /private/var/vm/sleepimage

# https://dortania.github.io/OpenCore-Post-Install/universal/sleep.html#preparations
sudo pmset powernap 0  # Used to periodically wake the machine for network, and updates(but not the display)
sudo pmset standby 0  # Used as a time period between sleep and going into hibernation
sudo pmset proximitywake 0  # Specifically when your iPhone or Apple Watch come near, the machine will wake
# sudo pmset tcpkeepalive 0  # TCP Keep Alive mechanism to prevent wake ups every 2 hours: Warning: This option disables TCP Keep Alive mechanism when sytem is sleeping. This will result in some critical features like 'Find My Mac' not to function properly.


###############################################################################
# Screen                                                                      #
###############################################################################


# do not automatically dim the built in laptop display when power is disconnected
defaults write -g AppleDisplayAutoBrightness -bool false

# Save screenshots to Pictures
defaults write com.apple.screencapture location -string "${HOME}/Pictures"

# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

# Disable shadow in screenshots
defaults write com.apple.screencapture disable-shadow -bool true

# Enable subpixel font rendering on non-Apple LCDs
# Reference: https://github.com/kevinSuttle/macOS-Defaults/issues/17#issuecomment-266633501
defaults write NSGlobalDomain AppleFontSmoothing -int 2
defaults write NSGlobalDomain CGFontRenderingFontSmoothingDisabled -bool false

# Enable HiDPI display modes (requires restart)
sudo defaults write /Library/Preferences/com.apple.windowserver DisplayResolutionEnabled -bool true


###############################################################################
# Nightlight                                                                  #
###############################################################################

# Start night shift from sunset to sunrise
nightlight schedule start


###############################################################################
# MonitorControl.app                                                          #
###############################################################################

# Only affects brightness, not contrast
defaults write me.guillaumeb.MonitorControl lowerContrast -bool false
defaults write me.guillaumeb.MonitorControl showContrast -bool false

# Do not modify all screens at once
defaults write me.guillaumeb.MonitorControl allScreens -bool false


###############################################################################
# Screen Saver                                                                #
###############################################################################

# Start screen saver after 10 minutes
defaults -currentHost write com.apple.screensaver idleTime -int 600

# Require password immediately after sleep or screen saver begins
#defaults write com.apple.screensaver askForPassword -bool true
#defaults write com.apple.screensaver askForPasswordDelay -int 0

# Screen Saver: Aerial
defaults -currentHost write com.apple.screensaver moduleDict -dict moduleName -string "Aerial" path -string "${HOME}/Library/Screen Savers/Aerial.saver" type -int 0


###############################################################################
# Aerial                                                                      #
###############################################################################

# Disable setup walkthrough
defaults write ~/Library/Containers/com.apple.ScreenSaver.Engine.legacyScreenSaver/Data/Library/Preferences/ByHost/com.JohnCoates.Aerial.plist \
    firstTimeSetup -int 1

# Disable fade in/out
defaults write ~/Library/Containers/com.apple.ScreenSaver.Engine.legacyScreenSaver/Data/Library/Preferences/ByHost/com.JohnCoates.Aerial.plist \
    fadeMode -int 0

# Video format: 4K HEVC
defaults write ~/Library/Containers/com.apple.ScreenSaver.Engine.legacyScreenSaver/Data/Library/Preferences/ByHost/com.JohnCoates.Aerial.plist \
    intVideoFormat -int 3

# Disable if battery < 20%
defaults write ~/Library/Containers/com.apple.ScreenSaver.Engine.legacyScreenSaver/Data/Library/Preferences/ByHost/com.JohnCoates.Aerial.plist \
    intOnBatteryMode -int 2

# Viewing mode: Cloned
defaults write ~/Library/Containers/com.apple.ScreenSaver.Engine.legacyScreenSaver/Data/Library/Preferences/ByHost/com.JohnCoates.Aerial.plist \
    newViewingMode -int 1

# Aligns scenes with system dark mode
defaults write ~/Library/Containers/com.apple.ScreenSaver.Engine.legacyScreenSaver/Data/Library/Preferences/ByHost/com.JohnCoates.Aerial.plist \
    timeMode -int 3

# Enable dynamic rotation of cache
defaults write ~/Library/Containers/com.apple.ScreenSaver.Engine.legacyScreenSaver/Data/Library/Preferences/ByHost/com.JohnCoates.Aerial.plist \
    enableManagement -int 1

# Rotate cache every month
defaults write ~/Library/Containers/com.apple.ScreenSaver.Engine.legacyScreenSaver/Data/Library/Preferences/ByHost/com.JohnCoates.Aerial.plist \
    intCachePeriodicity -int 2

# Limit cache to 20 Gb
defaults write ~/Library/Containers/com.apple.ScreenSaver.Engine.legacyScreenSaver/Data/Library/Preferences/ByHost/com.JohnCoates.Aerial.plist \
    cacheLimit -int 20

# Show download progress on screen saver
defaults write ~/Library/Containers/com.apple.ScreenSaver.Engine.legacyScreenSaver/Data/Library/Preferences/ByHost/com.JohnCoates.Aerial.plist \
    showBackgroundDownloads -int 1

# Deactivate debug mode and logs
defaults write ~/Library/Containers/com.apple.ScreenSaver.Engine.legacyScreenSaver/Data/Library/Preferences/ByHost/com.JohnCoates.Aerial.plist \
    debugMode -bool false

# Aerial layer widget configuration is a serialized JSON string. This hack will
# only allows preferences to be accounted for if all keys of a widget conf are
# present. See: https://github.com/JohnCoates/Aerial/issues/976

# Only shows clock on main diplays, without seconds or am/pm
defaults write ~/Library/Containers/com.apple.ScreenSaver.Engine.legacyScreenSaver/Data/Library/Preferences/ByHost/com.JohnCoates.Aerial.plist \
    LayerClock -string \
    '{
        "isEnabled": true,
        "displays": 1,
        "showSeconds": false,
        "hideAmPm": true,
        "clockFormat" : 1,
        "corner" : 3,
        "fontName" : "Helvetica Neue Medium",
        "fontSize" : 50
    }'

# Only shows location for 10 seconds on main display only
defaults write ~/Library/Containers/com.apple.ScreenSaver.Engine.legacyScreenSaver/Data/Library/Preferences/ByHost/com.JohnCoates.Aerial.plist \
    LayerLocation -string \
    '{
        "isEnabled": true,
        "displays": 1,
        "time": 1,
        "corner" : 7,
        "fontName" : "Helvetica Neue Medium",
        "fontSize" : 28
    }'

# Shows date on main display only
defaults write ~/Library/Containers/com.apple.ScreenSaver.Engine.legacyScreenSaver/Data/Library/Preferences/ByHost/com.JohnCoates.Aerial.plist \
    LayerDate -string \
    '{
        "isEnabled": true,
        "displays": 1,
        "format": 0,
        "withYear": true,
        "corner": 3,
        "fontName": "Helvetica Neue Thin",
        "fontSize": 25
    }'


###############################################################################
# Finder                                                                      #
###############################################################################


# Hide all desktop icons (useful when presenting)
defaults write com.apple.finder CreateDesktop -bool false

# Don't show icons for hard drives, servers, and removable media on the desktop
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false

# Finder: allow quitting via ⌘ + Q; doing so will also hide desktop icons
defaults write com.apple.finder QuitMenuItem -bool true

# Finder: disable window animations and Get Info animations
defaults write com.apple.finder DisableAllAnimations -bool true

# Set ${HOME} as the default location for new Finder windows
# Computer     : `PfCm`
# Volume       : `PfVo`
# $HOME        : `PfHm`
# Desktop      : `PfDe`
# Documents    : `PfDo`
# All My Files : `PfAF`
# Other…       : `PfLo`
defaults write com.apple.finder NewWindowTarget -string "PfHm"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

# Empty Trash securely by default
defaults write com.apple.finder EmptyTrashSecurely -bool true


# Finder: show hidden files by default
defaults write com.apple.finder AppleShowAllFiles -bool true

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Customize finder toolbar
defaults write com.apple.finder "NSToolbar Configuration Browser" '{ "TB Item Identifiers" = ( "com.apple.finder.BACK", "com.apple.finder.PATH", "com.apple.finder.SWCH", "com.apple.finder.ARNG", "NSToolbarFlexibleSpaceItem", "com.apple.finder.SRCH", "com.apple.finder.ACTN" ); "TB Display Mode" = 2; }'

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Enable spring loading for directories
# To use spring loading for directories, simply drag the file or folder over the target folder. As you drag, the target folder will open and you will be able to see the contents of the folder. Once you are satisfied with the location, release the mouse button to drop the file or folder into the target folder.
defaults write NSGlobalDomain com.apple.springing.enabled -bool true

# Remove the spring loading delay for directories
defaults write NSGlobalDomain com.apple.springing.delay -float 0

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Enable disk image verification
# checks for disk image corruption and integrity before mounting
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

# Automatically open a new Finder window when a volume is mounted
defaults write com.apple.frameworks.diskimages auto-open-ro-root -bool false
defaults write com.apple.frameworks.diskimages auto-open-rw-root -bool false
defaults write com.apple.finder OpenWindowForNewRemovableDisk -bool false

# # Set icon view settings on desktop and in icon views
# for view ('Desktop' 'FK_Standard' 'Standard'); do
#     # Show item info near icons on the desktop and in other icon views
#     # Show item info to the right of the icons on the desktop
#     # Enable snap-to-grid for icons on the desktop and in other icon views
#     # Increase grid spacing for icons on the desktop and in other icon views
#     # Increase the size of icons on the desktop and in other icon views
#     /usr/libexec/PlistBuddy \
#         -c "Set :${view}ViewSettings:IconViewSettings:showItemInfo  true"  \
#         -c "Set :${view}ViewSettings:IconViewSettings:labelOnBottom false" \
#         -c "Set :${view}ViewSettings:IconViewSettings:arrangeBy     grid"  \
#         -c "Set :${view}ViewSettings:IconViewSettings:gridSpacing   100"   \
#         -c "Set :${view}ViewSettings:IconViewSettings:iconSize      32"    \
#         ~/Library/Preferences/com.apple.finder.plist
# done



# Show item info below icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:showItemInfo true" ~/Library/Preferences/com.apple.finder.plist

# Enable snap-to-grid for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:arrangeBy grid" ~/Library/Preferences/com.apple.finder.plist

# Increase grid spacing for icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:gridSpacing 100" ~/Library/Preferences/com.apple.finder.plist

# Increase the size of icons on the desktop and in other icon views
/usr/libexec/PlistBuddy -c "Set :DesktopViewSettings:IconViewSettings:iconSize 60" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :FK_StandardViewSettings:IconViewSettings:iconSize 60" ~/Library/Preferences/com.apple.finder.plist
/usr/libexec/PlistBuddy -c "Set :StandardViewSettings:IconViewSettings:iconSize 60" ~/Library/Preferences/com.apple.finder.plist

# Use list view in all Finder windows by default
# Four-letter codes for the other view modes:
# Icon View   : `icnv`
# List View   : `Nlsv`
# Column View : `clmv`
# Cover Flow  : `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"


# View Options
# ColumnShowIcons    : Show preview column
# ShowPreview        : Show icons
# ShowIconThumbnails : Show icon preview
# ArrangeBy          : Sort by
#   dnam : Name
#   kipl : Kind
#   ludt : Date Last Opened
#   pAdd : Date Added
#   modd : Date Modified
#   ascd : Date Created
#   logs : Size
#   labl : Tags
/usr/libexec/PlistBuddy \
    -c "Delete :StandardViewOptions:ColumnViewOptions:ColumnShowIcons"    \
    -c "Delete :StandardViewOptions:ColumnViewOptions:FontSize"           \
    -c "Delete :StandardViewOptions:ColumnViewOptions:ShowPreview"        \
    -c "Delete :StandardViewOptions:ColumnViewOptions:ShowIconThumbnails" \
    -c "Delete :StandardViewOptions:ColumnViewOptions:ArrangeBy"          \
    ~/Library/Preferences/com.apple.finder.plist || true
/usr/libexec/PlistBuddy \
    -c "Add :StandardViewOptions:ColumnViewOptions:ColumnShowIcons    bool    true" \
    -c "Add :StandardViewOptions:ColumnViewOptions:FontSize           integer 11"   \
    -c "Add :StandardViewOptions:ColumnViewOptions:ShowPreview        bool    true" \
    -c "Add :StandardViewOptions:ColumnViewOptions:ShowIconThumbnails bool    true" \
    -c "Add :StandardViewOptions:ColumnViewOptions:ArrangeBy          string  dnam" \
    ~/Library/Preferences/com.apple.finder.plist

# Disable the warning before emptying the Trash
defaults write com.apple.finder WarnOnEmptyTrash -bool false

# Enable AirDrop over Ethernet and on unsupported Macs running Lion
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true

# Enable the MacBook Air SuperDrive on any Mac
# The MacBook Air SuperDrive is a small, lightweight device that is easy to carry with you. It connects to your MacBook Air via a USB port, and does not require any additional power.
#sudo nvram boot-args="mbasd=1"

# Show the ~/Library folder
chflags nohidden "${HOME}/Library" && xattr -d com.apple.FinderInfo "${HOME}/Library" 2> /dev/null || true

# Show the /Volumes folder
sudo chflags nohidden /Volumes

# Expand the following File Info panes:
# “General”, “Open with”, and “Sharing & Permissions”
defaults write com.apple.finder FXInfoPanesExpanded -dict \
    General -bool true \
    OpenWith -bool true \
    Privileges -bool true

# Prefer tabs when opening documents
defaults write -globalDomain "AppleWindowTabbingMode" -string "always"

# Copy window location: top right (as if it is a notification)
defaults write com.apple.finder CopyProgressWindowLocation -string "{2160, 23}"


###############################################################################
# Sets applications as default handlers for Apple's Uniform Type Identifiers
# Customize file assocations / Default Apps
###############################################################################
# Source: https://github.com/ptb/mac-setup/blob/develop/mac-setup.command#L2182-L2442

# https://github.com/moretension/duti

# Bundle Identifier > file type (UTI)
# How to find the bundle identifier: open plist of the app
# https://superuser.com/a/1577118

# How to find the UTI (file type) of the file 
# https://superuser.com/a/1577118
# mdls -name kMDItemContentType /path/to/file

# duti -s org.videolan.vlc public.audio all
# duti -s org.videolan.vlc public.aifc-audio all
# duti -s org.videolan.vlc com.microsoft.waveform-audio all
# duti -s org.videolan.vlc public.mp3 all
# duti -s org.videolan.vlc public.mpeg-4 all
# duti -s org.videolan.vlc com.microsoft.windows-media-wma all
# duti -s org.videolan.vlc public.aac-audio all
# duti -s org.videolan.vlc org.xiph.flac all
# duti -s org.videolan.vlc com.apple.m4a-audio all

duti -s com.macpaw.site.theunarchiver com.rarlab.rar-archive all

# To hunt IDs, see: http://stackoverflow.com/a/25622557

_duti='com.apple.DiskImageMounter com.apple.disk-image
com.apple.DiskImageMounter public.disk-image
com.apple.DiskImageMounter public.iso-image
com.apple.Terminal com.apple.terminal.shell-script
com.apple.installer com.apple.installer-package-archive
com.google.Chrome http
org.videolan.vlc com.apple.coreaudio-format
org.videolan.vlc com.apple.m4a-audio
org.videolan.vlc com.apple.m4v-video
org.videolan.vlc com.apple.mpeg-4-ringtone
org.videolan.vlc com.apple.protected-mpeg-4-audio
org.videolan.vlc com.apple.protected-mpeg-4-video
org.videolan.vlc com.apple.quicktime-movie
org.videolan.vlc com.audible.aa-audio
org.videolan.vlc com.microsoft.waveform-audio
org.videolan.vlc com.microsoft.windows-media-wmv
org.videolan.vlc public.ac3-audio
org.videolan.vlc public.aifc-audio
org.videolan.vlc public.aiff-audio
org.videolan.vlc public.audio
org.videolan.vlc public.audiovisual-content
org.videolan.vlc public.avi
org.videolan.vlc public.movie
org.videolan.vlc public.mp3
org.videolan.vlc public.mpeg
org.videolan.vlc public.mpeg-2-video
org.videolan.vlc public.mpeg-4
org.videolan.vlc public.mpeg-4-audio'

if test -x "/usr/local/bin/duti"; then
    test -f "${HOME}/Library/Preferences/org.duti.plist" && \
        rm "${HOME}/Library/Preferences/org.duti.plist"

    printf "%s\n" "${_duti}" | \
    while IFS="$(printf ' ')" read id uti; do
        defaults write org.duti DUTISettings -array-add \
            "{
                DUTIBundleIdentifier = '$id';
                DUTIUniformTypeIdentifier = '$uti';
                DUTIRole = 'all';
            }"
    done

    duti "${HOME}/Library/Preferences/org.duti.plist"
fi


###############################################################################
# iCloud                                                                      #
###############################################################################

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Disable Show warning before removing from iCloud Drive
defaults write com.apple.finder FXEnableRemoveFromICloudDriveWarning -bool false

# Allow Handoff between this Mac and your iCloud devices
# allows you to use Handoff to continue tasks on your other devices. Handoff is a feature that allows you to start an activity on one device and then pick it up where you left off on another device. 
# Apps that work with Handoff include Safari, Mail, Maps, Reminders, Calendar, Contacts, Pages, Numbers, Keynote, FaceTime* and many third-party apps.
# https://support.apple.com/en-gb/HT209455#:~:text=Open%20an%20app%20that%20works,email%20or%20creating%20a%20document.
#defaults -currentHost write com.apple.coreservices.useractivityd "ActivityAdvertisingAllowed" -bool true
#defaults -currentHost write com.apple.coreservices.useractivityd "ActivityReceivingAllowed" -bool true

# Sync Downloads folders to iCloud
# sudo rm -rf ~/Downloads/
# ln -s ~/Library/Mobile\ Documents/com~apple~CloudDocs/Downloads/ ~/Downloads

# Add an iCloud shortcut in home root.
# ln -f -s ~/Library/Mobile\ Documents/com~apple~CloudDocs ~/iCloud

###############################################################################
# Dock, Dashboard, and hot corners                                            #
###############################################################################

# Enable highlight hover effect for the grid view of a stack (Dock)
# https://www.defaults-write.com/enable-highlight-hover-effect-for-grid-view-stacks/
# not using stacks, using alfred or spotlight instead
defaults write com.apple.dock mouse-over-hilite-stack -bool true


# Set the icon size of Dock items to 36 pixels
defaults write com.apple.dock tilesize -int 52

# Enable magnification
# magnifies icons when you hover mouse over them
defaults write com.apple.dock "magnification" -bool true
defaults write com.apple.dock "largesize" -int 90

# Change minimize/maximize window effect ("scale" or "genie")
# https://macos-defaults.com/dock/mineffect.html
defaults write com.apple.dock mineffect -string "scale"

# Minimize windows into their application’s icon
defaults write com.apple.dock minimize-to-application -bool true

# Enable spring loading for all Dock items
defaults write com.apple.dock enable-spring-load-actions-on-all-items -bool true

# Show indicator lights for open applications in the Dock
defaults write com.apple.dock show-process-indicators -bool true


# Make Dock icons of hidden applications translucent
# defaults write com.apple.dock showhidden -bool true

# Wipe all (default) app icons from the Dock
# This is only really useful when setting up a new Mac, or if you don’t use
# the Dock to launch apps.
#defaults write com.apple.dock persistent-apps -array

# Do not only show open applications in the Dock
defaults write com.apple.dock static-only -bool false

# Don't show recent applications in the dock
defaults write com.apple.dock show-recents -bool true

# Don’t animate opening applications from the Dock
defaults write com.apple.dock launchanim -bool true

# Speed up Mission Control animations
defaults write com.apple.dock expose-animation-duration -float 0.1

# Don’t group windows by application in Mission Control
# (i.e. use the old Exposé behavior instead)
defaults write com.apple.dock expose-group-by-app -bool false

# Disable Dashboard
defaults write com.apple.dashboard mcx-disabled -bool true

# Don’t show Dashboard as a Space
defaults write com.apple.dock dashboard-in-overlay -bool true

# Don’t automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false



# Reset Launchpad
find ~/Library/Application\ Support/Dock -name "*.db" -maxdepth 1 -delete


# Remove the auto-hiding Dock delay
defaults write com.apple.dock autohide-delay -int 0
# Remove the animation when hiding/showing the Dock
defaults write com.apple.dock autohide-time-modifier -int 0

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# Make Dock icons of hidden applications translucent
defaults write com.apple.dock showhidden -bool true

# Enable the 2D Dock
#defaults write com.apple.dock no-glass -bool true

# Disable the Launchpad gesture (pinch with thumb and three fingers)
#defaults write com.apple.dock showLaunchpadGestureEnabled -int 0

# Make the cmd-tab app switcher show up on all monitors.
#defaults write com.apple.Dock appswitcher-all-displays -bool true

# Reset Launchpad, but keep the desktop wallpaper intact
command find "${HOME}/Library/Application Support/Dock" -maxdepth 1 -name "*-*.db" -delete

# Add iOS & Watch Simulator to Launchpad
#sudo ln -sf "/Applications/Xcode.app/Contents/Developer/Applications/Simulator.app" "/Applications/Simulator.app"
#sudo ln -sf "/Applications/Xcode.app/Contents/Developer/Applications/Simulator (Watch).app" "/Applications/Simulator (Watch).app"

# Add a spacer to the left side of the Dock (where the applications are)
#defaults write com.apple.dock persistent-apps -array-add '{tile-data={}; tile-type="spacer-tile";}'
# Add a spacer to the right side of the Dock (where the Trash is)
#defaults write com.apple.dock persistent-others -array-add '{tile-data={}; tile-type="spacer-tile";}'

# Hot corners
# Possible values:
#  0: no-op
#  2: Mission Control
#  3: Show application windows
#  4: Desktop
#  5: Start screen saver
#  6: Disable screen saver
#  7: Dashboard
# 10: Put display to sleep
# 11: Launchpad
# 12: Notification Center
# Top left screen corner → Start screen saver
defaults write com.apple.dock wvous-tl-corner -int 5
defaults write com.apple.dock wvous-tl-modifier -int 0

# Remove apps I don't use from the dock.
# disable dock completely?
# for shortcut_label (
#     "Contacts"
#     "FaceTime"
#     "Launchpad"
#     "Mail"
#     "Maps"
#     "Photos"
#     "Podcasts"
#     "Reminders"
#     "TV"
# ); do
#     dockutil --remove "${shortcut_label}" --allhomes --no-restart
# done

# Add new app shortcuts to the dock.
# for app (
#     "1Password 7"
#     "Fork"
#     "Home"
#     "LibreOffice"
#     "NetNewsWire"
#     "Signal"
#     "Spark"
#     "Tor Browser"
#     "Transmission"
#     "Visual Studio Code"
# ); do
#     if [[ $(dockutil --find "${app}" > /dev/null; echo $?) -ne 0 ]]; then
#         dockutil --add "/Applications/${app}.app" --replacing "${app}" --no-restart
#     fi
# done


# Enable iTunes track notifications in the Dock
defaults write com.apple.dock itunes-notifications -bool true

###############################################################################
# Safari & WebKit                                                             #
###############################################################################

# Privacy: don’t send search queries to Apple
defaults write com.apple.Safari UniversalSearchEnabled -bool false
defaults write com.apple.Safari SuppressSearchSuggestions -bool true

# Configure DuckDuckGo as main search engine
#defaults write com.apple.Safari SearchProviderIdentifier -string "com.duckduckgo"
#defaults write NSGlobalDomain NSProviderIdentifier -string "com.duckduckgo"

# Press Tab to highlight each item on a web page
#defaults write com.apple.Safari WebKitPreferences.tabFocusesLinks -bool true

# Show the full URL in the address bar (note: this still hides the scheme)
defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

# Safari > General > Safari opens with:
# false,false: A new window
# false,true: A new private window
# true, false: All windows from last session
defaults write com.apple.Safari AlwaysRestoreSessionAtLaunch -bool true
defaults write com.apple.Safari OpenPrivateWindowWhenNotRestoringSessionAtLaunch -bool false

# Setup new window and tab behvior
# 0: Homepage
# 1: Empty Page
# 2: Same Page
# 4: Start Page
defaults write com.apple.Safari NewTabBehavior -int 4
defaults write com.apple.Safari NewWindowBehavior -int 4

# Number of top sites to show:
# 6 top sites: 0
# 12 top sites: 1
# 24 top sites: 2
defaults write com.apple.Safari TopSitesGridArrangement -int 0

# Open pages in tabs instead of windows:
# 0: Never
# 1: Automatically
# 2: Always
defaults write com.apple.Safari TabCreationPolicy -int 2

# Set tab bar visibility
defaults write com.apple.Safari AlwaysShowTabBar -bool false

# cmd+click opens a link in a new tab
defaults write com.apple.Safari CommandClickMakesTabs -bool true

# When a new tab or window opens, make it active
defaults write com.apple.Safari OpenNewTabsInFront -bool false

# Use cmd+1 through cmd+9 to switch tabs
defaults write com.apple.Safari Command1Through9SwitchesTabs -bool true

# Set Safari’s home page to `about:blank` for faster loading
defaults write com.apple.Safari HomePage -string ""

# Save downloded files to
#defaults write com.apple.Safari DownloadsPath -string '~/Library/Mobile Documents/com~apple~CloudDocs/Downloads'

# Prevent Safari from opening ‘safe’ files automatically after downloading
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

# Save format
# 0: Page Source
# 1: Web Archive
defaults write com.apple.Safari SavePanelFileFormat -int 0

# Allow hitting the Backspace key to go to the previous page in history
#defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2BackspaceKeyNavigationEnabled -bool true

# Hide Safari’s bookmarks bar by default
defaults write com.apple.Safari ShowFavoritesBar -bool false
defaults write com.apple.Safari ShowFavoritesBar-v2 -bool false

# Show status bar
defaults write com.apple.Safari ShowStatusBar -bool true
defaults write com.apple.Safari ShowOverlayStatusBar -bool true
defaults write com.apple.Safari ShowStatusBarInFullScreen -bool true

# Disable: show toolbar in full screen
defaults write com.apple.Safari AutoShowToolbarInFullScreen -bool false

# Show Favorites under Smart Search field
# Smart Search is the dropdown when typing into the URL bar
defaults write com.apple.Safari ShowFavoritesUnderSmartSearchField -bool false

# Show Safari’s sidebar in new windows
defaults write com.apple.Safari ShowSidebarInNewWindows -bool true

# Show Safari’s sidebar in Top Sites
defaults write com.apple.Safari ShowSidebarInTopSites -bool true

# Show Sidebar Mode
# Values: "Bookmarks", "Reading List"
defaults write com.apple.Safari SidebarViewModeIdentifier -string  "Bookmarks"

# Preload Top Hit in the background
defaults write com.apple.Safari PreloadTopHit -bool false

# Disable Safari’s thumbnail cache for History and Top Sites
defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2

# Make Safari’s search banners default to Contains instead of Starts With
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false

# Remove useless icons from Safari’s bookmarks bar
defaults write com.apple.Safari ProxiesInBookmarksBar "()"

# Don't show frequently visited sites in Top bar
defaults write com.apple.SafariTechnologyPreview ShowFrequentlyVisitedSites -bool false

# Save article for offline reading automatically.
defaults write com.apple.Safari ReadingListSaveArticlesOfflineAutomatically -bool true

# Enable the Develop menu and the Web Inspector in Safari.
# Source: https://apple.stackexchange.com/a/429820
defaults write com.apple.Safari.SandboxBroker ShowDevelopMenu -bool true
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true

# Add a context menu item for showing the Web Inspector in web views.
# Source: https://blog.jim-nielsen.com/2022/inspecting-web-views-in-macos/
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true
defaults write -g WebKitDeveloperExtras -bool YES
# Enable Safari’s debug menu
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true

# Set default encoding
defaults write com.apple.Safari WebKitDefaultTextEncodingName -string 'utf-8'
defaults write com.apple.Safari WebKitPreferences.defaultTextEncodingName -string 'utf-8'

# Enable continuous spellchecking
defaults write com.apple.Safari WebContinuousSpellCheckingEnabled -bool true
# Disable auto-correct
defaults write com.apple.Safari WebAutomaticSpellingCorrectionEnabled -bool false

# Disable AutoFill
defaults write com.apple.Safari AutoFillPasswords -bool false
defaults write com.apple.Safari AutoFillFromAddressBook -bool false
defaults write com.apple.Safari AutoFillCreditCardData -bool false
defaults write com.apple.Safari AutoFillMiscellaneousForms -bool false

# Warn about fraudulent websites
defaults write com.apple.Safari WarnAboutFraudulentWebsites -bool true

# Enable JavaScript
# defaults write com.apple.Safari WebKitJavaScriptEnabled -bool true
# defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptEnabled -bool true

# Disable plug-ins
defaults write com.apple.Safari WebKitPluginsEnabled -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2PluginsEnabled -bool false

# Stop internet plug-ins to save power
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2PlugInSnapshottingEnabled -bool true

# Disable Java
defaults write com.apple.Safari WebKitJavaEnabled -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabled -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaEnabledForLocalFiles -bool false

# Block pop-up windows
defaults write com.apple.Safari WebKitJavaScriptCanOpenWindowsAutomatically -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2JavaScriptCanOpenWindowsAutomatically -bool false

# Disable auto-playing video
defaults write com.apple.Safari WebKitMediaPlaybackAllowsInline -bool false
defaults write com.apple.SafariTechnologyPreview WebKitMediaPlaybackAllowsInline -bool false
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2AllowsInlineMediaPlayback -bool false
defaults write com.apple.SafariTechnologyPreview com.apple.Safari.ContentPageGroupIdentifier.WebKit2AllowsInlineMediaPlayback -bool false

# Allow WebGL
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2WebGLEnabled -bool true

# Enable extensions
defaults write com.apple.Safari ExtensionsEnabled -bool true

# Update extensions automatically
defaults write com.apple.Safari InstallExtensionUpdatesAutomatically -bool true

# Cookies and website data:
# 0,2,2: Always block
# 3,1,1: Allow from current website only
# 2,1,1: Allow from websites I visit
# 1,0,0: Always allow
defaults write com.apple.Safari BlockStoragePolicy -int 2
defaults write com.apple.Safari WebKitStorageBlockingPolicy -int 1
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2StorageBlockingPolicy -int 1

# Deny location services access from websites
# 0: Deny without Prompting
# 1: Prompt for each website once each day
# 2: Prompt for each website one time only
defaults write com.apple.Safari SafariGeolocationPermissionPolicy -int 0

# Allow websites to ask for permission to send push notifications
defaults write com.apple.Safari CanPromptForPushNotifications -bool false

# Remove downloads list items
# 0: Manually
# 1: When Safari Quits
# 2: Upon Successful Download
defaults write com.apple.Safari DownloadsClearingPolicy -int 2

# Clear history:
# 1 = after one day
# 7 = after one week
# 14 = after two weeks
# 31 = after one month
# 365 = after one year
# 365000 = never (after 1000 years)
defaults write com.apple.Safari HistoryAgeInDaysLimit -int 14

# Don't allow apple pay checking.
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2ApplePayCapabilityDisclosureAllowed -bool false

# Disable website specific search.
defaults write com.apple.Safari WebsiteSpecificSearchEnabled -bool false

# Never use font sizes smaller than
defaults write com.apple.Safari WebKitMinimumFontSize -int 9
defaults write com.apple.Safari WebKitPreferences.minimumFontSize -int 9

# Print headers and footers
defaults write com.apple.Safari PrintHeadersAndFooters -bool false

# Print backgrounds
defaults write com.apple.Safari WebKitShouldPrintBackgroundsPreferenceKey -bool false
defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2ShouldPrintBackgrounds" -bool false





###############################################################################
# Spotlight                                                                   #
###############################################################################

# disable spotlight
# sudo launchctl unload -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist

# enable spotlight
sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.metadata.mds.plist
# how to allow apps to control computer
# for linktrigger: vlc

# Hide Spotlight tray-icon (and subsequent helper)
sudo chmod 600 /System/Library/CoreServices/Search.bundle/Contents/MacOS/Search || true

# Disable Spotlight indexing for any volume that gets mounted and has not yet
# been indexed before.
# Source: https://mattprice.me/2020/programmatically-modify-spotlight-ignore/
# sudo mdutil -i off "/Volumes"
# sudo /usr/libexec/PlistBuddy -c "Add :Exclusions: string /Volumes" \
#     /System/Volumes/Data/.Spotlight-V100/VolumeConfiguration.plist

# Change indexing order and disable some search results
# Yosemite-specific search results (remove them if you are using macOS 10.9 or older):
#     MENU_DEFINITION
#     MENU_CONVERSION
#     MENU_EXPRESSION
#     MENU_SPOTLIGHT_SUGGESTIONS (send search queries to Apple)
#     MENU_WEBSEARCH             (send search queries to Apple)
#     MENU_OTHER

# puts web searches at the bottom, and local files nearer the top
defaults write com.apple.spotlight orderedItems -array \
    '{"enabled" = 1;"name" = "APPLICATIONS";}' \
    '{"enabled" = 1;"name" = "SYSTEM_PREFS";}' \
    '{"enabled" = 1;"name" = "DIRECTORIES";}' \
    '{"enabled" = 1;"name" = "PDF";}' \
    '{"enabled" = 1;"name" = "FONTS";}' \
    '{"enabled" = 0;"name" = "DOCUMENTS";}' \
    '{"enabled" = 0;"name" = "MESSAGES";}' \
    '{"enabled" = 0;"name" = "CONTACT";}' \
    '{"enabled" = 0;"name" = "EVENT_TODO";}' \
    '{"enabled" = 0;"name" = "IMAGES";}' \
    '{"enabled" = 0;"name" = "BOOKMARKS";}' \
    '{"enabled" = 0;"name" = "MUSIC";}' \
    '{"enabled" = 0;"name" = "MOVIES";}' \
    '{"enabled" = 0;"name" = "PRESENTATIONS";}' \
    '{"enabled" = 0;"name" = "SPREADSHEETS";}' \
    '{"enabled" = 1;"name" = "SOURCE";}' \
    '{"enabled" = 0;"name" = "MENU_DEFINITION";}' \
    '{"enabled" = 0;"name" = "MENU_OTHER";}' \
    '{"enabled" = 1;"name" = "MENU_CONVERSION";}' \
    '{"enabled" = 1;"name" = "MENU_EXPRESSION";}' \
    '{"enabled" = 0;"name" = "MENU_WEBSEARCH";}' \
    '{"enabled" = 0;"name" = "MENU_SPOTLIGHT_SUGGESTIONS";}'
# Load new settings before rebuilding the index
killall mds &> /dev/null || true
# Make sure indexing is enabled for the main volume
sudo mdutil -i on / > /dev/null
# Rebuild the index from scratch
sudo mdutil -E / > /dev/null


###############################################################################
# QuickLook plugins                                                           #
###############################################################################

# Text selection in Quick Look
defaults write com.apple.finder QLEnableTextSelection -bool true

# Fix for the ancient UTF-8 bug in QuickLook (https://mths.be/bbo)
# Commented out, as this is known to cause problems in various Adobe apps :(
# See https://github.com/mathiasbynens/dotfiles/issues/237
#echo "0x08000100:0" > ~/.CFUserTextEncoding


###############################################################################
# Terminal                                                                    #
###############################################################################

# Set Zsh as default shell
#sudo chsh -s /bin/zsh $USERNAME
#sudo chsh -s /bin/zsh root

# Only use UTF-8 in Terminal.app
defaults write com.apple.terminal StringEncodings -array "4"

# Use specific color scheme and settings in Terminal.app
# (
# osascript <<EOF
# tell application "Terminal"

#     local allOpenedWindows
#     local initialOpenedWindows
#     local windowID
#     set themeName to "Monokai Soda"

#     (* Store the IDs of all the open terminal windows. *)
#     set initialOpenedWindows to id of every window

#     (* Open the custom theme so that it gets added to the list
#        of available terminal themes (note: this will open two
#        additional terminal windows). *)
#     do shell script "open './assets/" & themeName & ".terminal'"

#     (* Wait a little bit to ensure that the custom theme is added. *)
#     delay 1

#     (* Set the custom theme as the default terminal theme. *)
#     set default settings to settings set themeName

#     (* Get the IDs of all the currently opened terminal windows. *)
#     set allOpenedWindows to id of every window

#     repeat with windowID in allOpenedWindows

#         (* Close the additional windows that were opened in order
#            to add the custom theme to the list of terminal themes. *)
#         if initialOpenedWindows does not contain windowID then
#             close (every window whose id is windowID)

#         (* Change the theme for the initial opened terminal windows
#            to remove the need to close them in order for the custom
#            theme to be applied. *)
#         else
#             set current settings of tabs of (every window whose id is windowID) to settings set themeName
#         end if

#     end repeat

# end tell
# EOF
# ) || true

# Enable “focus follows mouse” for Terminal.app and all X11 apps
# i.e. hover over a window and start typing in it without clicking first
defaults write com.apple.terminal FocusFollowsMouse -bool true
defaults write org.x.X11 wm_ffm -bool true
defaults write org.x.X11 wm_click_through -bool true

# Enable Secure Keyboard Entry in Terminal.app
# See: https://security.stackexchange.com/a/47786/8918
# Secure keyboard entry can prevent other apps on your computer or the network from detecting and recording what you type in Terminal. Before you turn on secure keyboard entry, make sure other apps don't require keystrokes from Terminal.
defaults write com.apple.terminal SecureKeyboardEntry -bool true

# Disable the annoying line marks
# https://support.apple.com/en-gb/guide/terminal/trml135fbc26/mac
# [] and || on the left and right of the terminal app window
defaults write com.apple.Terminal ShowLineMarks -int 0

# Audible and Visual Bells
/usr/libexec/PlistBuddy \
    -c "Delete :WindowSettings:Basic:Bell"       \
    -c "Delete :WindowSettings:Basic:VisualBell" \
    ~/Library/Preferences/com.apple.terminal.plist || true
/usr/libexec/PlistBuddy \
    -c "Add    :WindowSettings:Basic:Bell       bool false" \
    -c "Add    :WindowSettings:Basic:VisualBell bool true"  \
    ~/Library/Preferences/com.apple.terminal.plist


###############################################################################
# Time Machine                                                                #
###############################################################################

# Source: https://krypted.com/mac-os-x/ins-outs-using-tmutil-backup-restore-review-time-machine-backups/

# Prevent Time Machine from prompting to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# Limit Time Machine total backup size to 1 TB (=1024*1024)
# Source: http://www.defaults-write.com/time-machine-setup-a-size-limit-for-backup-volumes/
sudo defaults write com.apple.TimeMachine MaxSize -integer 1048576

# Exclude Aerial screen saver big video cache.
AERIAL_CACHE="~/Library/Containers/com.apple.ScreenSaver.Engine.legacyScreenSaver/Data/Library/Application Support/Aerial/Cache"
if [[ -f "${AERIAL_CACHE}" ]]; then
    sudo tmutil addexclusion "${AERIAL_CACHE}"
fi

# Activate Time Machine backups (including local snapshots).
# sudo tmutil enable

###############################################################################
# Activity Monitor                                                            #
###############################################################################

# Show the main window when launching Activity Monitor
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true

# Show processes in Activity Monitor
# 100: All Processes
# 101: All Processes, Hierarchally
# 102: My Processes
# 103: System Processes
# 104: Other User Processes
# 105: Active Processes
# 106: Inactive Processes
# 106: Inactive Processes
# 107: Windowed Processes
defaults write com.apple.ActivityMonitor ShowCategory -int 100

# Sort Activity Monitor results by CPU usage
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0

# Set columns for each tab
defaults write com.apple.ActivityMonitor "UserColumnsPerTab v5.0" -dict \
    '0' '( Command, CPUUsage, CPUTime, Threads, IdleWakeUps, PID, UID )' \
    '1' '( Command, anonymousMemory, compressedMemory, ResidentSize, PurgeableMem, Threads, Ports, PID, UID)' \
    '2' '( Command, PowerScore, 12HRPower, AppSleep, graphicCard, UID )' \
    '3' '( Command, bytesWritten, bytesRead, Architecture, PID, UID )' \
    '4' '( Command, txBytes, rxBytes, txPackets, rxPackets, PID, UID )'

# Sort columns in each tab
defaults write com.apple.ActivityMonitor UserColumnSortPerTab -dict \
    '0' '{ direction = 0; sort = CPUUsage; }' \
    '1' '{ direction = 0; sort = ResidentSize; }' \
    '2' '{ direction = 0; sort = 12HRPower; }' \
    '3' '{ direction = 0; sort = bytesWritten; }' \
    '4' '{ direction = 0; sort = txBytes; }'

# Update Frequency (in seconds)
# 1: Very often (1 sec)
# 2: Often (2 sec)
# 5: Normally (5 sec)
defaults write com.apple.ActivityMonitor UpdatePeriod -int 2

# Show Data in the Disk graph (instead of IO)
defaults write com.apple.ActivityMonitor DiskGraphType -int 1

# Show Data in the Network graph (instead of packets)
defaults write com.apple.ActivityMonitor NetworkGraphType -int 1

# Visualize CPU usage in the Activity Monitor Dock icon
# 0: Application Icon
# 2: Network Usage
# 3: Disk Activity
# 5: CPU Usage
# 6: CPU History
defaults write com.apple.ActivityMonitor IconType -int 5








###############################################################################
# Dashboard, TextEdit and Disk Utility                                        #
###############################################################################

# Enable Dashboard dev mode (allows keeping widgets on the desktop)
defaults write com.apple.dashboard devmode -bool true

# Use plain text mode for new TextEdit documents
defaults write com.apple.TextEdit RichText -int 0
# Open and save files as UTF-8 in TextEdit
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

# Enable the debug menu in Disk Utility
defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true
defaults write com.apple.DiskUtility advanced-image-options -bool true

# Show All Devices
defaults write com.apple.DiskUtility SidebarShowAllDevices -bool true


###############################################################################
# QuickTime
###############################################################################

# Auto-play videos when opened with QuickTime Player
defaults write com.apple.QuickTimePlayerX MGPlayMovieOnOpen -bool true

# Set recording quality
# High:    MGCompressionPresetHighQuality
# Maximum: MGCompressionPresetMaximumQuality
defaults write com.apple.QuickTimePlayerX MGRecordingCompressionPresetIdentifier -string 'MGCompressionPresetMaximumQuality'

# Show mouse clicks in screen recordings
defaults write com.apple.QuickTimePlayerX MGScreenRecordingDocumentShowMouseClicksUserDefaultsKey -bool true


###############################################################################
# Mac App Store                                                               #
###############################################################################

# Enable the WebKit Developer Tools in the Mac App Store
defaults write com.apple.appstore WebKitDeveloperExtras -bool true

# Enable Debug Menu in the Mac App Store
defaults write com.apple.appstore ShowDebugMenu -bool true

# Turn on automatic checking for updates
sudo softwareupdate --schedule on

# Enable the automatic update check
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

# Check for software updates daily, not just once per week
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Download newly available updates in background
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

# Install System data files & security updates
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

# Automatically download apps purchased on other Macs
defaults write com.apple.SoftwareUpdate ConfigDataInstall -int 1

# Turn on app auto-update
defaults write com.apple.commerce AutoUpdate -bool true

# Disable: the App Store to reboot machine on macOS updates
defaults write com.apple.commerce AutoUpdateRestartRequired -bool false

# Turn off video autoplay.
defaults write com.apple.AppStore AutoPlayVideoSetting -string "off"
defaults write com.apple.AppStore UserSetAutoPlayVideoSetting -int 1


###############################################################################
# Photos                                                                      #
###############################################################################

# Prevent Photos from opening automatically when devices are plugged in
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool true


###############################################################################
# Menu Bar                                                                #
###############################################################################


# Menu bar: disable transparency
defaults write NSGlobalDomain AppleEnableMenuBarTransparency -bool false
 
# Menu bar: show remaining battery time (on pre-10.8); hide percentage
defaults write com.apple.menuextra.battery ShowPercent -string "NO"
defaults write com.apple.menuextra.battery ShowTime -string "YES"


# Menu bar: configure items
defaults write com.apple.systemuiserver menuExtras -array \
        "/System/Library/CoreServices/Menu Extras/TimeMachine.menu" \
        "/System/Library/CoreServices/Menu Extras/AirPort.menu" \
        "/System/Library/CoreServices/Menu Extras/Bluetooth.menu" \
        "/System/Library/CoreServices/Menu Extras/TextInput.menu" \
        "/System/Library/CoreServices/Menu Extras/Volume.menu" \
        "/System/Library/CoreServices/Menu Extras/Clock.menu"

# Enable input menu in menu bar.
defaults write com.apple.TextInputMenu visible -bool true
defaults write com.apple.TextInputMenuAgent "NSStatusItem Visible Item-0" -bool true

###############################################################################
# Kill affected applications                                                  #
###############################################################################

# for app (
#     "Activity Monitor"
#     "Address Book"
#     "Calendar"
#     "cfprefsd"
#     "Contacts"
#     "Dock"
#     "Finder"
#     "iCal"
#     "Mail"
#     "Messages"
#     "Photos"
#     "Safari"
#     "SystemUIServer"
#     "Transmission"
#     # Kill terminal last
#     "Terminal"
# ); do
#     killall "${app}" &> /dev/null || true
# done

for app in \
    Activity Monitor \
    Address Book \
    Calendar \
    cfprefsd \
    Contacts \
    Dock \
    Finder \
    iCal \
    Mail \
    Messages \
    Photos \
    Safari \
    SystemUIServer \
    Transmission \
; do
    killall "$app" &> /dev/null || true
done

# this should be in Finder section, run this last as it takes a while
# After configuring preferred view style, clear all `.DS_Store` files
# to ensure settings are applied for every directory
# DISABLED: if network drives are connected, this will delete all .DS_Store files across network drives
# sudo command find / -name ".DS_Store" -print -delete || true


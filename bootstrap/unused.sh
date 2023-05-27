#!/bin/sh




# Set highlight color to green
#defaults write NSGlobalDomain AppleHighlightColor -string "0.764700 0.976500 0.568600"

# ENABLE: Sys Prefs > Appearance > Accent Color int
#defaults write NSGlobalDomain AppleAquaColorVariant -int 6

# Disable smooth scrolling
# (Uncomment if you’re on an older Mac that messes up the animation)
#defaults write NSGlobalDomain NSScrollAnimationEnabled -bool false

# Remove duplicates in the “Open With” menu (also see `lscleanup` alias)
# /System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user


##############################################################################
# Security                                                                   #
##############################################################################

# Enable Firewall. Possible values: 0 = off, 1 = on for specific sevices, 2 =
# on for essential services.
#sudo defaults write /Library/Preferences/com.apple.alf globalstate -int 1

# Enable stealth mode
# https://support.apple.com/kb/PH18642
# When stealth mode is on, your Mac doesn't respond to either “ping” requests or connection attempts from a closed TCP or UDP network.
# sudo defaults write /Library/Preferences/com.apple.alf stealthenabled -bool true

# Enable firewall logging
#sudo defaults write /Library/Preferences/com.apple.alf loggingenabled -bool true

# Do not automatically allow signed software to receive incoming connections
#sudo defaults write /Library/Preferences/com.apple.alf allowsignedenabled -bool false

# Reload the firewall
# (uncomment if above is not commented out)
# launchctl unload /System/Library/LaunchAgents/com.apple.alf.useragent.plist
#sudo launchctl unload /System/Library/LaunchDaemons/com.apple.alf.agent.plist
#sudo launchctl load /System/Library/LaunchDaemons/com.apple.alf.agent.plist
#launchctl load /System/Library/LaunchAgents/com.apple.alf.useragent.plist

# Apply configuration on all network interfaces.
#   $ networksetup -listallnetworkservices
#   An asterisk (*) denotes that a network service is disabled.
#   Thunderbolt Ethernet Slot 1, Port 1
#   *Thunderbolt Ethernet Slot 1, Port 2
#   Wi-Fi
#   iPhone USB
#   Bluetooth PAN
#   Thunderbolt Bridge
net_interfaces=$(networksetup -listallnetworkservices | awk '{gsub(/^*/,""); if(NR>1)print}')
for net_service (${(f)net_interfaces}); do
    # Use Cloudflare's fast and privacy friendly DNS.
    networksetup -setdnsservers "${net_service}" 1.1.1.1 1.0.0.1 2606:4700:4700::1111 2606:4700:4700::1001
    # Clear out all search domains.
    networksetup -setsearchdomains "${net_service}" "Empty"
    # Setup 10G NIC.
    if [ "${net_service}" = "Thunderbolt Ethernet Slot 1, Port 2" ]; then
        networksetup -setMTU "${net_service}" 9000
    fi
done

# Turn Bluetooth off completely
#sudo defaults write /Library/Preferences/com.apple.Bluetooth ControllerPowerState -int 0

# Disable wifi captive portal
# wifi captive portal is the popup that lets you login to a public wifi network after joining
# sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.captive.control Active -bool false



# Destroy FileVault key when going into standby mode, forcing a re-auth.
# Source: https://web.archive.org/web/20160114141929/https://training.apple.com/pdf/WP_FileVault2.pdf
# sudo pmset destroyfvkeyonstandby 1

# Add sudo 2FA based on Touch ID. Source: https://twitter.com/cabel/status/931292107372838912
# sudo tee -a "/etc/pam.d/sudo" <<-EOF
# auth       sufficient     pam_tid.so
# EOF

# Enable FileVault (if not already enabled)
# This requires a user password, and outputs a recovery key that should be
# copied to a secure location
# if [[ $(sudo fdesetup status | head -1) == "FileVault is Off." ]]; then
#   sudo fdesetup enable -user $(whoami)
# fi

# Disable automatic login when FileVault is enabled
#sudo defaults write /Library/Preferences/com.apple.loginwindow DisableFDEAutoLogin -bool true


# Log firewall events for 90 days.
# sudo perl -p -i -e 's/rotate=seq compress file_max=5M all_max=50M/rotate=utc compress file_max=5M ttl=90/g' "/etc/asl.conf"
# sudo perl -p -i -e 's/appfirewall.log file_max=5M all_max=50M/appfirewall.log rotate=utc compress file_max=5M ttl=90/g' "/etc/asl.conf"

# Log authentication events for 90 days.
#sudo perl -p -i -e 's/rotate=seq file_max=5M all_max=20M/rotate=utc file_max=5M ttl=90/g' "/etc/asl/com.apple.authd"

# Log installation events for a year.
#sudo perl -p -i -e 's/format=bsd/format=bsd mode=0640 rotate=utc compress file_max=5M ttl=365/g' "/etc/asl/com.apple.install"

# Increase the retention time for system.log and secure.log (CIS Requirement 1.7.1I)
#sudo perl -p -i -e 's/\/var\/log\/wtmp.*$/\/var\/log\/wtmp   \t\t\t640\ \ 31\    *\t\@hh24\ \J/g' "/etc/newsyslog.conf"

# CIS 3.3 audit_control flags setting.
#sudo perl -p -i -e 's|flags:lo,aa|flags:lo,aa,ad,fd,fm,-all,^-fa,^-fc,^-cl|g' /private/etc/security/audit_control
# sudo perl -p -i -e 's|filesz:2M|filesz:10M|g' /private/etc/security/audit_control
# sudo perl -p -i -e 's|expire-after:10M|expire-after: 30d |g' /private/etc/security/audit_control



##############################################################################
# 1Password                                                                  #
##############################################################################

# Show 1Password in the menu bar
defaults write com.agilebits.onepassword7 "MASPreferences Selected Identifier View" -string "General"
defaults write com.agilebits.onepassword7 ShowStatusItem -bool false

# Show rich icons
defaults write com.agilebits.onepassword7 ShowRichIcons -bool true

# Show item count in sidebar
defaults write com.agilebits.onepassword7 ShowItemCounts -bool false

# Format secure notes using Markdown
defaults write com.agilebits.onepassword7 EnableMarkdown -bool true

# Require Master Password every 2 days
defaults write com.agilebits.onepassword7 OPPrefMasterPasswordTimeoutInMinutesKey -int 2880

# Conceal passwords
defaults write com.agilebits.onepassword7 ConcealPasswords -bool true

# Lock on sleep
defaults write com.agilebits.onepassword7 LockOnSleep -bool true

# Lock when screen saver is activated
defaults write com.agilebits.onepassword7 LockOnScreenSaver -bool true

# Lock when main window is closed
defaults write com.agilebits.onepassword7 LockOnMainAppExit -bool false

# Lock when fast user switching
defaults write com.agilebits.onepassword7 LockOnUserSwitch -bool true

# Lock after computer is idle for 5 minutes
defaults write com.agilebits.onepassword7 LockOnIdle -bool true
defaults write com.agilebits.onepassword7 LockTimeout -int 5

# Clear clipboard contents after 45 secondes
defaults write com.agilebits.onepassword7 ClearPasteboardAfterTimeout -bool true
defaults write com.agilebits.onepassword7 PasteboardClearTimeout -int 45

# Check for compromised websites
defaults write com.agilebits.onepassword7 watchtowerService -bool true

# Check for vulnerable passwords
defaults write com.agilebits.onepassword7 compromisedPasswordServiceV2 -bool true

# Check for two-factor authentication
defaults write com.agilebits.onepassword7 twoFactorService -bool true

# Ask before checking for a secure connection
defaults write com.agilebits.onepassword7 watchtowerMakeHTTPSAlwaysAskForConsent -bool true

# Always keep 1Password Extension Helper running
defaults write com.agilebits.onepassword7 KeepHelperRunning -bool true

# Show inline menu in Safari
defaults write com.agilebits.onepassword7 OPPrefShowSafariInlineMenu -bool true

# Automaticcaly show inline menu when selecting a field
defaults write com.agilebits.onepassword7 OPPrefShowSafariInlineMenuAutomatically -bool true

# Detect new usernames and passwords and offer to save them
defaults write com.agilebits.onepassword7 autosave -bool true

# Automaticcaly copy one-time passwords
defaults write com.agilebits.onepassword7 CopyTOTPToClipboard -bool true

# Notifications: One-time passwords
defaults write com.agilebits.onepassword7 OPPreferencesNotifyOfTOTPCopy -bool true

# Notifications: Vault access
defaults write com.agilebits.onepassword7 OPPreferencesNotifyVaultAddedRemoved -bool true

# Notifications: Watchdog alerts
defaults write com.agilebits.onepassword7 OPPreferencesNotifyCompromisedWebsites -bool true



###############################################################################
# Mail                                                                        #
###############################################################################

# Disable send and reply animations in Mail.app
defaults write com.apple.mail DisableReplyAnimations -bool true
defaults write com.apple.mail DisableSendAnimations -bool true

# Copy email addresses as `foo@example.com` instead of `Foo Bar <foo@example.com>` in Mail.app
defaults write com.apple.mail AddressesIncludeNameOnPasteboard -bool false

# Add the keyboard shortcut ⌘ + Enter to send an email in Mail.app
defaults write com.apple.mail NSUserKeyEquivalents -dict-add "Send" "@\U21a9"

# Display emails in threaded mode, sorted by date (oldest at the top)
defaults write com.apple.mail DraftsViewerAttributes -dict-add "DisplayInThreadedMode" -string "yes"
defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortedDescending" -string "yes"
defaults write com.apple.mail DraftsViewerAttributes -dict-add "SortOrder" -string "received-date"

# Disable inline attachments (just show the icons)
defaults write com.apple.mail DisableInlineAttachmentViewing -bool true

# Disable automatic spell checking
defaults write com.apple.mail SpellCheckingBehavior -string "NoSpellCheckingEnabled"

# Show To/Cc label in message list
defaults write com.apple.mail EnableToCcInMessageList -bool true


###############################################################################
# iWork                                                                       #
###############################################################################

## Keynote

#defaults write com.apple.iWork.Keynote 'ShowStartingPointsForNewDocument' -bool false
defaults write com.apple.iWork.Keynote 'dontShowWhatsNew' -bool true
defaults write com.apple.iWork.Keynote 'FirstRunFlag' -bool true

## Numbers

#defaults write com.apple.iWork.Numbers 'ShowStartingPointsForNewDocument' -bool false
defaults write com.apple.iWork.Numbers 'dontShowWhatsNew' -bool true
defaults write com.apple.iWork.Numbers 'FirstRunFlag' -bool true

## Pages

#defaults write com.apple.iWork.Pages 'ShowStartingPointsForNewDocument' -bool false
defaults write com.apple.iWork.Pages 'dontShowWhatsNew' -bool true
defaults write com.apple.iWork.Pages 'FirstRunFlag' -bool true

###############################################################################
# Quartz Debug                                                                #
###############################################################################

# Lets the window list work.
#defaults write com.apple.QuartzDebug QuartzDebugPrivateInterface -bool YES

# Show useful things in the dock icon.
#defaults write com.apple.QuartzDebug QDDockShowFramemeterHistory -bool YES
#defaults write com.apple.QuartzDebug QDDockShowNumericalFps -bool YES

# Identify which app a window belongs to (press ⌃⌥ while hovering over it).
#defaults write com.apple.QuartzDebug QDShowWindowInfoOnMouseOver -bool YES



###############################################################################
# Contacts                                                                    #
###############################################################################

# Enable the debug menu in Address Book
defaults write com.apple.addressbook ABShowDebugMenu -bool true

# Show first name
# false : Before last name
# true  : Following last name
defaults write com.apple.AddressBook ABNameDisplay -bool false

# Sort by
defaults write com.apple.AddressBook ABNameSortingFormat -string "sortingLastName sortingFirstName"

# Short name format
# 0: Full Name
# 1: First Name & Last Initial
# 2: First Initial & Last Name
# 3: First Name Only
# 4: Last Name Only
defaults write com.apple.AddressBook ABShortNameStyle -int 2

# Prefer nicknames
defaults write com.apple.AddressBook ABShortNamePrefersNickname -bool true

# Address format
defaults write com.apple.AddressBook ABDefaultAddressCountryCode -string "us"

# vCard Format
# falsec: 3.0
# true  : 2.1
defaults write com.apple.AddressBook ABUse21vCardFormat -bool false

# Enable private me card
defaults write com.apple.AddressBook ABPrivateVCardFieldsEnabled -bool false

# Export notes in vCards
defaults write com.apple.AddressBook ABIncludeNotesInVCard -bool false

# Export photos in vCards
defaults write com.apple.AddressBook ABIncludePhotosInVCard -bool false

# Show first name:
# 1: Before last name
# 2: Following last name
defaults write NSGlobalDomain NSPersonNameDefaultDisplayNameOrder -int 1

# Prefer nicknames
defaults write NSGlobalDomain NSPersonNameDefaultShouldPreferNicknamesPreference -bool true


###############################################################################
# Calendar                                                                    #
###############################################################################

# Enable the debug menu in iCal (pre-10.8)
defaults write com.apple.iCal IncludeDebugMenu -bool true

# Days per week
defaults write com.apple.iCal "n days of week" -int 7

# Start week on:
# 0: Sunday
# 6: Saturday
defaults write com.apple.iCal "first day of week" -int 1

# Scroll in week view by:
# 0: Day
# 1: Week
# 2: Week, Stop on Today
defaults write com.apple.iCal "scroll by weeks in week view" -int 1

# Day starts at:
defaults write com.apple.iCal "first minute of work hours" -int 480

# Day ends at:
defaults write com.apple.iCal "last minute of work hours" -int 1080

# Show X hours at a time
defaults write com.apple.iCal "number of hours displayed" -int 16

# Turn on timezone support
defaults write com.apple.iCal "TimeZone support enabled" -bool true

# Show events in year view
defaults write com.apple.iCal "Show heat map in Year View" -bool true

# Show week numbers
defaults write com.apple.iCal "Show Week Numbers" -bool true

# Open events in separate windows
# defaults write com.apple.iCal OpenEventsInWindowType -bool true

# Ask before sending changes to events
defaults write com.apple.iCal WarnBeforeSendingInvitations -bool true

###############################################################################
# Messages                                                                    #
###############################################################################

# Disable automatic emoji substitution (i.e. use plain text smileys)
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticEmojiSubstitutionEnablediMessage" -bool false

# Disable smart quotes as it’s annoying for messages that contain code
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "automaticQuoteSubstitutionEnabled" -bool false

# Disable continuous spell checking
defaults write com.apple.messageshelper.MessageController SOInputLineSettings -dict-add "continuousSpellCheckingEnabled" -bool false

# Save history when conversations are closed
defaults write com.apple.iChat SaveConversationsOnClose -bool true

# Text size
# 1: Small
# 7: Large
defaults write com.apple.iChat TextSize -int 2

# Animate buddy pictures
defaults write com.apple.iChat AnimateBuddyPictures -bool false

# Play sound effects
defaults write com.apple.messageshelper.AlertsController PlaySoundsKey -bool false

# Notify me when my name is mentioned
defaults write com.apple.messageshelper.AlertsController SOAlertsAddressMeKey -bool false

# Notify me about messages form unknown contacts
defaults write com.apple.messageshelper.AlertsController NotifyAboutKnockKnockKey -bool false

# Show all buddy pictures in conversations
defaults write com.apple.iChat ShowAllBuddyPictures -bool false


###############################################################################
# NetNewsWire                                                                 #
###############################################################################

# # Check for stable updates.
# defaults write com.ranchero.NetNewsWire-Evergreen SUAutomaticallyUpdate -int 1
# defaults write com.ranchero.NetNewsWire-Evergreen SUEnableAutomaticChecks -int 1
# defaults write com.ranchero.NetNewsWire-Evergreen SUHasLaunchedBefore -int 1

# # Refresh every 4 hours.
# defaults write com.ranchero.NetNewsWire-Evergreen refreshInterval -int 6

# # Hide read feeds and articles.
# defaults write com.ranchero.NetNewsWire-Evergreen windowState -dict-add readFeedsFilterState -bool true
# defaults write com.ranchero.NetNewsWire-Evergreen windowState -dict-add readArticlesFilterStateValue -bool true
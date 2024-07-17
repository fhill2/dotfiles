# Apps to implement in the fufutre

# Display ASCII control characters using caret notation in standard text views
# Try e.g. `cd /tmp; unidecode "\x{0000}" > cc.txt; open -e cc.txt`
defaults write NSGlobalDomain NSTextShowsControlCharacters -bool true

# Set a custom wallpaper image. `DefaultDesktop.jpg` is already a symlink, and
# all wallpapers are in `/Library/Desktop Pictures/`. The default is `Wave.jpg`.
#rm -rf "${HOME}/Library/Application Support/Dock/desktoppicture.db"
#sudo rm -rf /System/Library/CoreServices/DefaultDesktop.jpg
#sudo ln -s /path/to/your/image /System/Library/CoreServices/DefaultDesktop.jpg

# Disable transparency in the menu bar and elsewhere on Yosemite
#defaults write com.apple.universalaccess reduceTransparency -bool true

# Autohide dock and menubar.
# this is enabled by default on fresh ventura install
#defaults write NSGlobalDomain _HIHideMenuBar -bool true

###############################################################################
# Stats                                                                       #
###############################################################################

# # Activate custom config.
# defaults write eu.exelban.Stats version -string "2.7.8"

# # CPU widget:
# # - line chart display
# # - display line chart and hide all others
# # - show value
# # - colorize value
# # - colorize based on utilization
# defaults write eu.exelban.Stats CPU_widget -string "line_chart"
# defaults write eu.exelban.Stats CPU_line_chart_box -bool true
# defaults write eu.exelban.Stats CPU_line_chart_frame -bool false
# defaults write eu.exelban.Stats CPU_line_chart_value -bool true
# defaults write eu.exelban.Stats CPU_line_chart_valueColor -bool true
# defaults write eu.exelban.Stats CPU_line_chart_color -string "utilization"

# # Deactivate RAM widget.
# defaults write eu.exelban.Stats RAM_state -bool false

# # Disk widget:
# # - hide removable disks
# defaults write eu.exelban.Stats Disk_state -bool true
# defaults write eu.exelban.Stats Disk_widget -string "memory"
# defaults write eu.exelban.Stats Disk_removable -bool false

# # Sensors widget:
# # - Show first efficiency and performance core temperatures
# defaults write eu.exelban.Stats Sensors_state -bool true
# defaults write eu.exelban.Stats sensor_Tp01 -bool true
# defaults write eu.exelban.Stats sensor_Tp09 -bool true

# # Network widget:
# # - arrows pictogram
# defaults write eu.exelban.Stats Network_speed_icon -string "arrows"

# # Battery widget:
# # - low level notification at 10%
# # - display percentage and time
# # - colorize
# defaults write eu.exelban.Stats Battery_battery_additional -string "percentageAndTime"
# defaults write eu.exelban.Stats Battery_lowLevelNotification -string "0.1"
# defaults write eu.exelban.Stats Battery_battery_color -bool true

###############################################################################
# AdGuard                                                                     #
###############################################################################

# # Do not block search ads and websites' self-promotion
# defaults write com.adguard.mac.adguard UsefulAdsEnabled -bool false

# # Activate language-specific filters automaticcaly
# defaults write com.adguard.mac.adguard ActivateFiltersAutomaticEnabled -bool true

# # Launch AdGuard at Login
# defaults write com.adguard.mac.adguard StartAtLogin -bool true

# # Hide menu bar icon
# defaults write com.adguard.mac.adguard HideMenubarIcon -bool false

# # Enable filters
# defaults write com.adguard.mac.adguard FilteringEnabled -bool true

# # TODO: activate all filters
# # Seems to be saved at: ~/Library/Group Containers/XXXXXXXX.com.adguard.mac/Library/Application Support/com.adguard.mac.adguard/adguard.db

# # Advanced tracking protection
# defaults write com.adguard.mac.adguard StealthEnabled -bool true

# # Hide your search queries
# defaults write com.adguard.mac.adguard StealthHideSearchQueries -bool true

# # Send Do-Not-Track header
# defaults write com.adguard.mac.adguard StealthSendDoNotTrackHeader -bool false

# # Strip tracking parameters
# defaults write com.adguard.mac.adguard StealthStripUrl -bool true

# # Self-destruction of third-party cookies after a 10 minutes TTL
# defaults write com.adguard.mac.adguard StealthBlockThirdPartyCookiesMin -int 10

# # Self-destruction of first-party cookies
# defaults write com.adguard.mac.adguard StealthBlockFirstPartyCookies -bool true

# # Disable cache for third-party requests
# defaults write com.adguard.mac.adguard StealthDisableThirdPartyCache -bool true

# # Block third-party Authorization header
# defaults write com.adguard.mac.adguard StealthBlockThirdPartyAuthorization -bool true

# # Block WebRTC
# defaults write com.adguard.mac.adguard StealthBlockWebRtc -bool true

# # Block Push API
# defaults write com.adguard.mac.adguard StealthBlockBrowserPushApi -bool true

# # Block Location API
# defaults write com.adguard.mac.adguard StealthBlockBrowserLocationApi -bool true

# # Block Java
# defaults write com.adguard.mac.adguard StealthBlockBrowserJava -bool true

# # Hide Referrer from third-parties
# defaults write com.adguard.mac.adguard StealthRemoveReferrerFromThirdPartyRequests -bool true

# # Hide your User-Agent
# defaults write com.adguard.mac.adguard StealthHideUserAgent -bool true

# # Mask your IP address
# defaults write com.adguard.mac.adguard StealthHideIp -bool true

# # Remove X-Client-Data header
# defaults write com.adguard.mac.adguard StealthRemoveXClientDataHeader -bool true

# # Phishing and malware protection
# defaults write com.adguard.mac.adguard SafebrowsingEnabled -bool true

# # Help us with Browsing security filters development
# defaults write com.adguard.mac.adguard SafebrowsingHelpEnabled -bool false

# # Extensions
# defaults write com.adguard.mac.adguard UserscriptsEnabled -bool true

# # AdGuard Extra
# defaults write com.adguard.mac.adguard ExtraEnabled -bool true

# # Automaticcally filter applications
# defaults write com.adguard.mac.adguard NetworkFilterEnabled -bool true

# # Filter HTTPS protocol
# defaults write com.adguard.mac.adguard FilterHttps -bool true

# # Do not filter websites with EV certificates
# defaults write com.adguard.mac.adguard IgnoreEvSslCertificates -bool false

###############################################################################
# iiNA                                                                        #
###############################################################################

# XXX PlistBuddy seems to overflow with too much commands. Split in two to manage it.
# /usr/libexec/PlistBuddy \
#     -c "Clear dict" \
#     -c "Add :SUAutomaticallyUpdate          integer 1" \
#     -c "Add :SUEnableAutomaticChecks        integer 1" \
#     -c "Add :SUScheduledCheckInterval       integer 604800" \
#     -c "Add :receiveBetaUpdate              integer 0" \
#     -c "Add :SUHasLaunchedBefore            integer 1" \
#     -c "Add :SUSendProfileInfo              integer 0" \
#     -c "Add :enableAdvancedSettings         integer 1" \
#     -c "Add :enableLogging                  integer 0" \
#     -c "Add :quitWhenNoOpenedWindow         integer 1" \
#     -c "Add :keepOpenOnFileEnd              integer 0" \
#     -c "Add :resumeLastPosition             integer 0" \
#     ~/Library/Preferences/com.colliderli.iina.plist

# /usr/libexec/PlistBuddy \
#     -c "Add :recordRecentFiles              integer 0" \
#     -c "Add :recordPlaybackHistory          integer 0" \
#     -c "Add :trackAllFilesInRecentOpenMenu  integer 0" \
#     -c "Add :playlistAutoAdd                integer 0" \
#     -c "Add :playlistAutoPlayNext           integer 0" \
#     -c "Add :screenShotFolder               string  '~/Desktop'" \
#     -c "Add :themeMaterial                  integer 4" \
#     -c "Add :resizeWindowTiming             integer 0" \
#     ~/Library/Preferences/com.colliderli.iina.plist

# /usr/libexec/PlistBuddy \
#     -c "Add :controlBarToolbarButtons       array" \
#     -c "Add :controlBarToolbarButtons:0     integer 2" \
#     -c "Add :controlBarToolbarButtons:0     integer 1" \
#     -c "Add :controlBarToolbarButtons:0     integer 5" \
#     -c "Add :controlBarToolbarButtons:0     integer 0" \
#     -c "Add :showChapterPos                 integer 1" \
#     -c "Add :autoSearchOnlineSub            integer 1" \
#     -c "Add :ytdlSearchPath                 string  ''" \
#     ~/Library/Preferences/com.colliderli.iina.plist

# # Link legacy youtube-dl binary to maintained yt-dlp. Sources:
# # https://github.com/iina/iina/issues/3327#issuecomment-998184733
# # https://github.com/iina/iina/issues/3502
# sudo rm /Applications/IINA.app/Contents/MacOS/youtube-dl
# sudo ln -fs $(which yt-dlp) /Applications/IINA.app/Contents/MacOS/youtube-dl

###############################################################################
# Transmission.app                                                            #
###############################################################################

# Automatically size window to fit all transfers
defaults write org.m0k.transmission AutoSize -bool true

# Download & Upload Badges
defaults write org.m0k.transmission BadgeDownloadRate -bool false
defaults write org.m0k.transmission BadgeUploadRate -bool false

# Default download location
defaults write org.m0k.transmission DownloadLocationConstant -bool true
defaults write org.m0k.transmission DownloadChoice -string "Constant"
defaults write org.m0k.transmission DownloadFolder -string "${HOME}/Downloads"

# Use `${HOME}/Torrents` to store incomplete downloads
defaults write org.m0k.transmission UseIncompleteDownloadFolder -bool true
defaults write org.m0k.transmission IncompleteDownloadFolder -string "${HOME}/Torrents"

# Use `${HOME}/Downloads` to store completed downloads
defaults write org.m0k.transmission DownloadLocationConstant -bool true

# Don’t prompt for confirmation before downloading
defaults write org.m0k.transmission DownloadAsk -bool false
defaults write org.m0k.transmission MagnetOpenAsk -bool false

# Display window when opening a torrent file
defaults write org.m0k.transmission DownloadAskMulti -bool true
defaults write org.m0k.transmission DownloadAskManual -bool true

# Automatic Import
defaults write org.m0k.transmission AutoImport -bool true
defaults write org.m0k.transmission AutoImportDirectory -string "${HOME}/Downloads/"

# Prompt user for removal of active transfers only when downloading
defaults write org.m0k.transmission CheckRemoveDownloading -bool true

# Do not prompt user for quit, whether there is an active transfer or download.
defaults write org.m0k.transmission CheckQuit -bool false
defaults write org.m0k.transmission CheckQuitDownloading -bool false

# Trash original torrent files
defaults write org.m0k.transmission DeleteOriginalTorrent -bool true

# Hide the donate message
defaults write org.m0k.transmission WarningDonate -bool false
# Hide the legal disclaimer
defaults write org.m0k.transmission WarningLegal -bool false

# Don't play a download sound
defaults write org.m0k.transmission PlayDownloadSound -bool false

# IP block list.
# Source: https://giuliomac.wordpress.com/2014/02/19/best-blocklist-for-transmission/
defaults write org.m0k.transmission BlocklistNew -bool true
defaults write org.m0k.transmission BlocklistURL -string "https://github.com/Naunter/BT_BlockLists/raw/master/bt_blocklists.gz"
defaults write org.m0k.transmission BlocklistAutoUpdate -bool true

# Randomize port on launch
defaults write org.m0k.transmission RandomPort -bool true

# Require encryption
defaults write org.m0k.transmission EncryptionRequire -bool true

# Do not prevent computer from sleeping with active transfer
defaults write org.m0k.transmission SleepPrevent -bool false

# Status bar
defaults write org.m0k.transmission StatusBar -bool true

# Small view
defaults write org.m0k.transmission SmallView -bool true

# Pieces bar
defaults write org.m0k.transmission PiecesBar -bool false

# Pieces bar
defaults write org.m0k.transmission FilterBar -bool true

# Availability
defaults write org.m0k.transmission DisplayProgressBarAvailable -bool false

###############################################################################
# MusicBrainz.app                                                             #
###############################################################################

# Auto-trigger new file analysis.
defaults write com.musicbrainz.Picard setting.analyze_new_files -bool true

# Do not ask confirmation on quit.
defaults write com.musicbrainz.Picard setting.quit_confirmation -bool false

# Allow auth connection to MusicBrainz website for contributions.
defaults write com.musicbrainz.Picard setting.server_host -string "musicbrainz.org"
defaults write com.musicbrainz.Picard setting.username -string "kdeldycke"
defaults write com.musicbrainz.Picard setting.password -string ""

# Setup file renaming settings.
defaults write com.musicbrainz.Picard setting.rename_files -bool true
defaults write com.musicbrainz.Picard setting.ascii_filenames -bool false
defaults write com.musicbrainz.Picard setting.windows_compatibility -bool true
defaults write com.musicbrainz.Picard setting.move_files -bool true
defaults write com.musicbrainz.Picard setting.move_files_to -string "${HOME}/Music"
defaults write com.musicbrainz.Picard setting.delete_empty_dirs -bool true

# Fallback on image release group if no front-cover found.
defaults write com.musicbrainz.Picard setting.ca_provider_use_caa_release_group_fallback -bool true

# Allow connections to AcoustID.
defaults write com.musicbrainz.Picard setting.fingerprinting_system -string "acoustid"
defaults write com.musicbrainz.Picard setting.acoustid_apikey -string "lP2ph5Sm"

###############################################################################
# Fork
# https://git-fork.com
###############################################################################

# Check stable update every week.
defaults write com.DanPristupov.Fork SUAutomaticallyUpdate -int 1
defaults write com.DanPristupov.Fork applicationUpdateChannel -int 1
defaults write com.DanPristupov.Fork SUScheduledCheckInterval -int 604800

# Default repository source.
defaults write com.DanPristupov.Fork defaultSourceFolder -string "~"

# Set font.
defaults write com.DanPristupov.Fork diffFontName -string "SauceCodeProNerdFontComplete-Regular"
defaults write com.DanPristupov.Fork diffFontSize -int 11

# Disable telemetry.
defaults write com.DanPristupov.Fork disableAnonymousUsageReports -int 1

# Use latest git from brew.
defaults write com.DanPristupov.Fork gitInstanceType -int 3

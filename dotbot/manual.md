___
TODO / TO AUTOMATE (not needed just yet):
upload ssh key to github
___
# NOT NEEDED - only for multi disk btrfs setups
add to /etc/mkinitcpio.conf MODULES (only needed for : 
MODULES=(btrfs)
mkinitcpio -p linux




add to /etc/snapper/configs/root:
ALLOW_USERS="f1"

arch recommended settings:
TIMELINE_MIN_AGE="1800"
TIMELINE_LIMIT_HOURLY="5"
TIMELINE_LIMIT_DAILY="7"
TIMELINE_LIMIT_WEEKLY="0"
TIMELINE_LIMIT_MONTHLY="0"
TIMELINE_LIMIT_YEARLY="0"


___
~/.config/syncthing/config.xml
change <address></address> to 0.0.0.0
this allows connecting to show syncthing web gui over LAN
cant sync this file as it contains device IDs
and cba to script with aug or sed
```xml
<gui enabled="true" tls="false" debugging="false">
<address>0.0.0.0:8384</address>
<apikey>Po7cHpbLHs7sjRuNRJkJXQG2gxstbuxC</apikey>
<theme>default</theme>
</gui>
```
___
open arandr
modify layout, resolutions of screens
save as..to desktop - qtile autostart.sh xrandr executes on startup

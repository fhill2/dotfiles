___
# NOT NEEDED - only for multi disk btrfs setups
# BTRFS only manual bootstrap setup
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



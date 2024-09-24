#!/bin/bash
# OUTPUT from this script is output into ~/.local/share/qtile/qtile.log
currentDate=`date`

echo "$currentDate : START AUTOSTART.SH"
dunst &
xmousepasteblock &
redshift -P -O 4900
# autorandr --load monitor_left
sudo kmonad ~/dot/kmonad/config.kbd &
echo "$currentDate : END AUTOSTART.SH"

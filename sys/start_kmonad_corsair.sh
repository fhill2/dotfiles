#!/usr/bin/sh
#kmonad /home/f1/dot/kmonad/corsair.kbd >> $HOME/logs/kmonad.log 2>&1 &

export XAUTHORITY=$XAUTHORITY
export DISPLAY=$DISPLAY
export HOME=$HOME
env >> /tmp/udev-env-test.txt
su f1 -c 'export DISPLAY=:0; notify-send "corsair connected"'
echo "corsair ran" >> /tmp/udev-env-test.txt

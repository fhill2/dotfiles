#!bin/sh

### RUN /etc/X11/xinit/xinitrc
#. /etc/X11/xinit/xinitrc

#https://wiki.archlinux.org/title/environment_variables
#export PATH="${PATH}:/home/my_user/bin"


#xrandr --dpi 196
#xrandr --dpi 196

#if [[ "$HOSTNAME" == "arch-lap" ]]; then
# exec /usr/bin/prime-offload
# xrandr --setprovideroutputsource modesetting NVIDIA-0
# xrandr --auto



# exported from arandr
# xrandr monitor layout has to be before qtile because qtile needs the correct screen layout to place widgets, otherwise it errors

#/home/f1/Desktop/xrandr.sh &

#fi

#/usr/bin/prime-offload

#https://wiki.archlinux.org/title/Xorg/Keyboard_configuration#Using_setxkbmap
# setxkbmap -model pc105 -layout us


sudo tzupdate # auto change timezone based on IP address - before qtile starts otherwise clocks arent set
# exec qtile start 2>&1 > ~/.local/share/qtile/qtile.log
#exec qtile start -c ~/dot/qtile/config2.py


# i3
dunst &
xmousepasteblock &
redshift -P -O 4900
nm-applet &
autorandr --change
# setxkbmap -model pc105 -layout us

sudo kmonad ~/dot/kmonad/config.kbd >> $HOME/logs/kmonad.log 2>&1 &
# show stderr (custom script errors) and stdout (custom script print statements) in sxhkd.log
sxhkd >> $HOME/logs/sxhkd.log 2>&1 &

# https://www.reddit.com/r/i3wm/comments/i9xu28/where_does_i3_write_its_log_file/
exec i3 -V -d all &>> "$HOME/logs/i3.log"
# exec i3
#exec herbstluftwm

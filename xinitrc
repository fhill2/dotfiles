#!bin/sh


#https://wiki.archlinux.org/title/environment_variables
#export PATH="${PATH}:/home/my_user/bin"


#xrandr --dpi 196
#xrandr --dpi 196

#if [[ "$HOSTNAME" == "arch-lap" ]]; then
# exec /usr/bin/prime-offload
xrandr --setprovideroutputsource modesetting NVIDIA-0
xrandr --auto



# exported from arandr
# xrandr monitor layout has to be before qtile because qtile needs the correct screen layout to place widgets, otherwise it errors

#/home/f1/Desktop/xrandr.sh &

#fi

#/usr/bin/prime-offload


sudo tzupdate # auto change timezone based on IP address - before qtile starts otherwise clocks arent set
exec qtile start
#exec qtile start -c ~/dot/qtile/config2.py
#exec i3

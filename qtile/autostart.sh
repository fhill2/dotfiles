#!/bin/bash
# OUTPUT from this script is output into ~/.local/share/qtile/qtile.log
currentDate=`date`

echo "$currentDate : START AUTOSTART.SH"

#[ -f /home/f1/Desktop/xrandr.sh ] && 
# exec blocks
# &

# laptop - tangerine
xrandr --output DP-0 --off --output DP-1 --off --output DP-2 --off --output DP-3 --off --output DP-4 --mode 3840x2160 --pos 0x0 --rotate normal --output DP-5 --off --output DP-6 --off --output DP-7 --off --output eDP-1-1 --mode 2560x1600 --pos 3840x560 --rotate normal --output DP-1-1 --off --output DP-1-2 --off --output DP-1-3 --off --output DP-1-4 --off

# london - desktop
#xrandr --output DP-0 --off --output DP-1 --off --output DP-2 --off --output DP-3 --off --output DP-4 --off --output DP-5 --off --output DP-6 --primary --mode 3840x2160 --pos 2560x0 --rotate normal --output DP-7 --off --output eDP-1-1 --mode 2560x1600 --pos 0x560 --rotate normal --output DP-1-1 --off --output DP-1-2 --off --output DP-1-3 --off --output DP-1-4 --off



#sudo systemctl daemon-reload
#sudo systemctl start kvm.service

# If the process doesn't exists, start one in background
run() {
	if ! pgrep $1 ; then
		$@ &
	fi
}

# Just as the above, but if the process exists, restart it
run-or-restart() {
	if ! pgrep $1 ; then
		$@ &
	else
		process-restart $@
	fi
}

#dunst &
#xmousepasteblock &
#f_start_nemo_preview.sh &


echo "$currentDate : END AUTOSTART.SH"

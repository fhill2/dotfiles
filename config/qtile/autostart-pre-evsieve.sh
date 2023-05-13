#!/bin/bash
#xrandr --output DisplayPort-0 --primary --mode 3840x2160 --pos 3840x0 --rotate normal --output DisplayPort-1 --off --output HDMI-A-0 --mode 3840x2160 --pos 0x0 --rotate normal --output HDMI-A-1 --off
#xrandr --output DisplayPort-0 --primary --mode 3840x2160 --pos 3840x0 --rotate normal --output DisplayPort-1 --off --output DisplayPort-2 --mode 3840x2160 --pos 0x0 --rotate normal --output DisplayPort-3 --off
#xrandr --dpi 96 
#xrandr --dpi 96

# reset/restart xmodmap and xcape
setxkbmap -layout us
pkill xcape

# setxkbmap -option ctrl:nocaps
# xcape -e 'Control_L=Escape' # physical Lctrl --> virtual Esc
# xmodmap -e "Escape=F14" # physical escape --> F14


#https://unix.stackexchange.com/questions/345116/remap-esc-to-caps-lock-after-mapping-caps-lock-to-ctrl-and-esc-with-xcape
# Remove Caps_Lock modifier from real Caps Lock key
xmodmap -e "clear Lock"
# Set real Caps Lock key to present as (left) control
xmodmap -e "keycode 66 = Control_R"
# Set real Escape key to present as Caps Lock
#xmodmap -e "keycode 9 = Caps_Lock"
xmodmap -e "keycode 9 = F14"
# Make a fake key to hold the Escape keysym, so xcape can use it
xmodmap -e "keycode 255 = Escape"
# Make Caps_Lock and Control_L work as one would expect
#xmodmap -e "add Lock = Caps_Lock"
xmodmap -e "add Control = Control_R"
xcape -e '#66=Escape'

# order matters
xmodmap -e "keycode 37 = Super_L"
xmodmap -e "remove control = Super_L"
echo "LOADED STARTUP"
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
run dunst

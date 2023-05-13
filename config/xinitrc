# # https://cewood.xyz/posts/my-i3-setup/
# if the nvidia optimus prime render default xorg config is used
# and this line is not set - all screens are black
# xrandr --setprovideroutputsource modesetting NVIDIA-0
# xrandr --auto
# this was not enabled
# xrandr --output eDP-1-1 --set "PRIME Synchronization" 1 --output DP-1-3 --set "PRIME Synchronization" 1
#
# # main xrandr gets applied by mons when first starting up
# # mons does not re apply xrandr if logging in /out
#

# https://wiki.archlinux.org/title/Display_Power_Management_Signaling
# keep dpms on but set timeout to infinity
xset dpms 0 0 0
# disable screen blanking
xset s off
# disables dpms and screen blanking
# xset s off -dpms

# # ~/.Xresources IS NOT read when launching with startx / xinitrc
# # ~/.Xresources does not support comments with #
# # https://bbs.archlinux.org/viewtopic.php?id=208894
xrdb -load ~/.Xresources
#
#
# # Propogate DISPLAY vars to Systemd, for more info see this
# #  https://wiki.archlinux.org/index.php/Systemd/User#Environment_variables
# # https://wiki.archlinux.org/title/Systemd/User
# # before starting any systemd user services, import the given environment variables into the user systemd environment
systemctl --user import-environment DISPLAY WAYLAND_DISPLAY
#
#
# # so I can use i3-msg or swaymsg interchangably in bash scripts
if [[ ! -z "${DISPLAY}" ]]; then
  [[ "$(readlink /usr/bin/swaymsg)" != "/usr/bin/i3-msg" ]] && sudo ln -sf /usr/bin/i3-msg /usr/bin/swaymsg
fi
#
if [[ ! -z "${WAYLAND_DISPLAY}" ]]; then
  [[ "$(readlink /usr/bin/i3-msg)" != "/usr/bin/swaymsg" ]] && sudo ln -sf /usr/bin/swaymsg /usr/bin/i3-msg
fi

# start scripts
x_profiles 2
redshift -O 4900

# sudo ln -s $PWD/45-discrete-gpu-render.conf /etc/X11/xorg.conf.d/45-discrete-gpu-render.conf 
#
case "$1" in
nv)
  sudo ln -sf /home/f1/dot/sys/45-discrete-gpu-render.conf /etc/X11/xorg.conf.d/45-discrete-gpu-render.conf
  exec /usr/bin/i3 > ~/logs/i3.log 2>&1
  ;;
gnome)
  exec /usr/bin/gnome-session
  ;;
i3-gnome)
  exec /usr/bin/i3-gnome
  ;;
*)
  exec /usr/bin/i3 > ~/logs/i3.log 2>&1
  ;;
esac

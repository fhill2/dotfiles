udevmon_input=/dev/input/$(ls /sys/devices/virtual/input/input* | grep ^event)
echo $udevmon_input
sudo ln -s $udevmon_input /home/f1/code/keymaps/kmonad/udevmon_input


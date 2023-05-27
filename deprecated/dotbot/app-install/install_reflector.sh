if ! pacman -Qe reflector > /dev/null 2>&1; then
    sudo pacman -S reflector
    systemctl enable --now reflector.service
    systemctl enable reflector.timer
fi

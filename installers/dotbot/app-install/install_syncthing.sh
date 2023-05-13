# if syncthing does not exist
if ! pacman -Qe syncthing > /dev/null 2>&1; then
    sudo pacman -S syncthing
    systemctl enable --now syncthing@f1.service
    rm /home/f1/Sync # delete syncthing default folder

    # now turn syncthing on
    xdg-open http://127.0.0.1:8384
    # http://192.168.0.100:8384/syncthing/ <- for NAS syncthing config
fi

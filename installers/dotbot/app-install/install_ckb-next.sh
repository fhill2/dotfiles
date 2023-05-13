# if ckb-next is not installed
if ! pacman -Qe ckb-next > /dev/null 2>&1; then
  yay -S ckb-next && sudo systemctl enable --now ckb-next
fi

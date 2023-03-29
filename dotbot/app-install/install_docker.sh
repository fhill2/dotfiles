# if docker is not installed
if ! pacman -Qe docker > /dev/null 2>&1; then
  sudo pacman -S docker
  sudo usermod -aG docker f1
  sudo systemctl enable --now docker.service
  echo "docker requires restart / logout to start"
fi


# ssh is installed with arch-ext4 installer - this generates ssh keys
SSH_PRIVATE_KEY="$HOME/.ssh/$HOST"
if [[ ! -e "$SSH_PRIVATE_KEY" ]]; then
  echo "Generating SSH key..."
  ssh-keygen -b 2048 -t ed25519 -f "$SSH_PRIVATE_KEY" -q -N "" -C "freddiehill000@gmail.com"
  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/$HOST
  # TODO: upload key to github
fi

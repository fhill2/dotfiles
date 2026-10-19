#!/usr/bin/env sh
# Install the systemd user ssh-agent service (Linux/Ubuntu only)
# The agent is owned by systemd - shells only point at its socket

set -e

if [ "$(uname -s)" != "Linux" ]; then
  echo "ssh-agent service is Linux only - nothing to do"
  exit 0
fi

mkdir -p "$HOME/.config/systemd/user" "$HOME/.config/environment.d"

cp "$HOME/dot/config/systemd/user/ssh-agent.service" "$HOME/.config/systemd/user/ssh-agent.service"
cp "$HOME/dot/config/systemd/environment.d/20-ssh-agent.conf" "$HOME/.config/environment.d/20-ssh-agent.conf"

if [ -f "$HOME/.ssh/f_github" ]; then
  chmod 600 "$HOME/.ssh/f_github"
fi

systemctl --user daemon-reload
systemctl --user enable --now ssh-agent.service

systemctl --user --no-pager status ssh-agent.service | head -5
ssh-add -l

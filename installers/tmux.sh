# TPM is deprecated
# tpack init is an alternative but did not show a UI when I tested on OSX

if [ "$HOST" = "Darwin" ]; then
  brew install tmuxpack/tpack/tpack
else
  echo "install tmuxpack/tpack"
fi

# minimal-tmux-status - loaded directly by tmux.conf via run-shell, not by a plugin manager
if [ ! -d "$HOME/dot/config/tmux/plugins/minimal-tmux-status" ]; then
  git clone https://github.com/niksingh710/minimal-tmux-status "$HOME/dot/config/tmux/plugins/minimal-tmux-status"
fi

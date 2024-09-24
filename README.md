
# Why symlink ~/.local/bin -> ~/dot/bin?

~/.local/bin is not included on $PATH on osx or linux by default, so it makes no difference if ~/dot/bin is added to $PATH or ~/.local/bin is added to $PATH.

When using homebrew on linux, there can be package conflicts with linux's system package manager, and homebrew. Therefore, I am only using the system's package manager or installing from source.




## Best Sensible Pane Defaults


window splits:
sway b v
lazy.nvim | -
tmux % "

export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

export FZF_DEFAULT_COMMAND="rg --files --hidden --glob '!{node_modules/*,.git/*}'"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS='--no-height --layout=reverse --border'
export FZF_TMUX=1

#https://github.com/junegunn/fzf/issues/1839
# fzf uses find by default
export FZF_DEFAULT_COMMAND='fd --type f --exclude .git --follow --hidden'


export EDITOR=nvim


# aliases less -> lesspipe which allows less pager to show contents of a lot of extra files, such as .pdf, .docx etc
# export LESSOPEN="|lesspipe.sh %s"
# export LESSQUIET=1
# export PAGER=nvimpager


# Path
# homebrew binary after ~/.local/bin on path, so I can override fd with a shim that always invokes fd with -L (to use fd with a global config that is useful for telescope and invocation via CLI)
export PATH=/opt/homebrew/bin:$PATH
# Apparently `brew doctor` says i need it.
export PATH="/opt/homebrew/sbin:$PATH"

export PATH="$HOME/.local/bin:/usr/local/bin:$PATH"
export PATH="$HOME/.yarn/bin:$PATH"
export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"
export PATH="./node_modules/.bin:$PATH"
export PATH="$PATH:$HOME/.config/base16-shell"

[ -f $HOME/.cargo/env ] && source $HOME/.cargo/env

export PYENV_VIRTUALENV_DISABLE_PROMPT=1
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

if command -v yarn >/dev/null 2>&1; then
  export PATH="$PATH:`yarn global bin`"
fi


export HOMEBREW_NO_AUTO_UPDATE=1

export _ZO_FZF_OPTS="$FZF_DEFAULT_OPTS"

# ________________________________

#export PASSWORD_STORE_DIR="$HOME/data/.password-store"

# Python
# [[ "$(uname)" == "Darwin" ]] && export PYTHON_CONFIGURE_OPTS="--enable-framework"
# [[ "$(uname)" == "Linux" ]] && export PYTHON_CONFIGURE_OPTS="--enable-shared"


# distant.nvim plugin auto installs distant binary to ~/.local/share/nvim/distant.nvim/bin
# + there is no homebrew package
# export PATH="$HOME/.local/share/nvim/distant.nvim/bin:$PATH"

# Restic/Backblaze
# restic mount -r $SYNC_REPO ~/backblaze
#export RESTIC_REPOSITORY="b2:dbalatero-backup"
#export SYNC_REPO="$RESTIC_REPOSITORY:/Sync"
#export FREEZE_REPO="$RESTIC_REPOSITORY:/Freeze"

# dotfiles
# export PATH=$PATH:$HOME/dot/bin

# export PATH=$HOME/.work-cli/bin:$PATH



# Keyboard/qmk
#export PATH="/opt/homebrew/opt/avr-gcc@8/bin:$PATH"
#export PATH="/opt/homebrew/opt/arm-gcc-bin@8/bin:$PATH"

# zoxide
# zoxide doesnt read from $FZF_DEFAULT_OPTS by default


# switched to rbw
# rbw = bitwarden cli that manages state
# so it can be used like pass in this way (gpg agent)
# OPENAI_KEY=$(pass ls openai/api)
# export AICHAT_API_KEY="$OPENAI_KEY" # aichat rust TUI
# export OPENAI_API_KEY="$OPENAI_KEY" # chatGPT.nvim



# https://stackoverflow.com/a/61870689
# export PATH="/usr/local/opt/tcl-tk/bin:$PATH"

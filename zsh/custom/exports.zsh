# Tmux UTF8 support
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

# enable git scripts
export DEVELOPMENT_DIRECTORY="$HOME/code"


# ========== FZF ===========
# dbalatero
export FZF_DEFAULT_COMMAND="rg --files --hidden --glob '!{node_modules/*,.git/*}'"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

export FZF_DEFAULT_OPTS='--no-height --layout=reverse --border'
# export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
export FZF_TMUX=1

#https://github.com/junegunn/fzf/issues/1839
# fzf uses find by default
export FZF_DEFAULT_COMMAND='fd --type f --exclude .git --follow --hidden'

# ==========================
# Editor
export EDITOR=nvim

# aliases less -> lesspipe which allows less pager to show contents of a lot of extra files, such as .pdf, .docx etc
# export LESSOPEN="|lesspipe.sh %s"
# export LESSQUIET=1
# export PAGER=nvimpager

# Path
export PATH="$HOME/.local/bin:/usr/local/bin:$PATH"
export PATH="$HOME/.yarn/bin:$PATH"
export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"



export PATH="./node_modules/.bin:$PATH"
export PATH="$PATH:$HOME/.config/base16-shell"

# Cargo
[ -f $HOME/.cargo/env ] && source $HOME/.cargo/env

# Python
[[ "$(uname)" == "Darwin" ]] && export PYTHON_CONFIGURE_OPTS="--enable-framework"
[[ "$(uname)" == "Linux" ]] && export PYTHON_CONFIGURE_OPTS="--enable-shared"

export PYENV_VIRTUALENV_DISABLE_PROMPT=1
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

# Restic/Backblaze
# restic mount -r $SYNC_REPO ~/backblaze
#export RESTIC_REPOSITORY="b2:dbalatero-backup"
#export SYNC_REPO="$RESTIC_REPOSITORY:/Sync"
#export FREEZE_REPO="$RESTIC_REPOSITORY:/Freeze"

# Yarn
if command -v yarn >/dev/null 2>&1; then
  export PATH="$PATH:`yarn global bin`"
fi

# Don't be helpful
export HOMEBREW_NO_AUTO_UPDATE=1



# dotfiles
export PATH=$PATH:$HOME/dot/bin

export PATH=$HOME/.work-cli/bin:$PATH

# brew mac m1
export PATH=/opt/homebrew/bin:$PATH
# Apparently `brew doctor` says i need it.
export PATH="/opt/homebrew/sbin:$PATH"

# Keyboard/qmk
#export PATH="/opt/homebrew/opt/avr-gcc@8/bin:$PATH"
#export PATH="/opt/homebrew/opt/arm-gcc-bin@8/bin:$PATH"

# zoxide
# zoxide doesnt read from $FZF_DEFAULT_OPTS by default
export _ZO_FZF_OPTS="$FZF_DEFAULT_OPTS"

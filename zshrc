## ======= ZPLUG======


source /usr/share/zsh/scripts/zplug/init.zsh 
zplug 'zsh-users/zsh-completions'
zplug 'agkozak/zhooks'
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug 'NullSense/fuzzy-sys'
zplug 'zsh-users/zsh-autosuggestions'



zplug "jeffreytse/zsh-vi-mode"
zplug "marlonrichert/zsh-edit"
#source ~/shell/me-plug/tmux-snippets/tmux-snippets.zsh
#eval "$(lua /home/f1/.zplug/repos/skywind3000/z.lua/z.lua --init zsh)"

#zplug 'skywind3000/z.lua'
# # zplug 'lincheney/fzf-tab-completion'
# zplug 'wfxr/forgit'

# https://github.com/zsh-users/zsh-syntax-highlighting/issues/871
ZVM_INIT_MODE='sourcing'
source ~/dev/zsh-src/vi-mode.zsh

if ! zplug check --verbose; then
  printf "Install? [y/N]: "
  if read -q; then
    echo; zplug install
  fi
fi
zplug load




HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt appendhistory


## ======= PLUGIN ZSH-AUTOCOMPLETE ======
## zstyle ':autocomplete:*' min-delay 0.1
#LISTMAX=-1
zstyle ':autocomplete:*' min-input 2

# fix: remove 'do you want to see all possibilities' message
zstyle -d ':completion:*' list-prompt
zstyle -d ':completion:*' select-prompt
zstyle ':completion:*' list-prompt   '%S%m%s'
zstyle ':completion:*' select-prompt '%S%m%s'




eval "$(starship init zsh)"

# ============== FUNCTIONS ===============

alias rm=trash
alias ls='ls --color'
alias lua='lua5.1'
alias nv='nvim'


alias howdoi='~/.venv/howdoi/bin/howdoi'

eval "$(zoxide init zsh)"
#
#
#
#https://askubuntu.com/questions/410048/utf-8-character-not-showing-properly-in-tmux
# icons arent showing in tmux - this is because if UTF-8 substring doesnt exist in these variables, tmux doesnt display unicode
# also tmux doesnt run without this
export LC_ALL=en_GB.UTF-8
export LANG=en_GB.UTF-8

#GHORG_GITHUB_TOKEN=$(pass show gh/pat-ghorg)

# aliases less -> lesspipe which allows less pager to show contents of a lot of extra files, such as .pdf, .docx etc
export LESSOPEN="|lesspipe.sh %s"
export LESSQUIET=1
export PAGER=nvimpager






# fzf
export FZF_DEFAULT_OPTS='--no-height --layout=reverse --border'
export FZF_TMUX=1

#https://github.com/junegunn/fzf/issues/1839
# fzf uses find by default
export FZF_DEFAULT_COMMAND='fd --type f --exclude .git --follow --hidden'

#https://archive.zhimingwang.org/blog/2015-09-21-zsh-51-and-bracketed-paste.html
# zle_bracketed_paste is causing spam when launching fzf function
unset zle_bracketed_paste


# direnv
eval "$(direnv hook zsh)"
# pyenv
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
#eval "$(pyenv init -)"
# pyenv virtualenv
#eval "$(pyenv virtualenv-init -)"



# the-way
tws() {
  PREV=$(fc -lrn | head -n 1)
  sh -c "the-way cmd `printf %q "$PREV"`"
}

f_tw_zle() {
  BUFFER=$(the-way search --stdout --languages="sh")
   CURSOR=$#BUFFER
   #zle redisplay
  #print -z $BUFFER
}

f_tw() {
result=$(the-way search --stdout --languages="sh")
eval "$result"
}




zle -N f_tw
#bindkey '^m' tw

######

ghc() {
  # clones by ssl link, which automatically sets remote origin to an ssl link
  # if first arg is actually a url, extract repo username from url
  if [[ $1 == http* ]]; then
  repouser=$(grep -Po '\w\K/\w+[^?]+' <<<$1 | cut -c 2-)
  else
  repouser=$1
  fi

  git clone git@github.com:${repouser}.git
}

qt() {
  # -N --> shutdown the network socket after EOF on the input
echo "$1" | nc -N localhost 7113
}


flog() {
selection="$(python /home/f1/dev/python/bin/flog.py)"
sudo tail -f $selection 2> /dev/null | bat --paging=never -l log
echo "$selection"
}


fzf_md() {
  file=$(fd readme --exact-depth 1 -e .md -e .rst $(find_git_repos $PWD) | xargs realpath --no-symlinks --relative-to="${PWD}" | fzf --preview 'mdcat {}')
  mdcat $file
}



mkcd() {
  dir="$*";
  mkdir -p "$dir" && cd "$dir";
}


pp() {
echo $1 | tr ':' '\n'
}

# fzf
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

#https://github.com/junegunn/fzf/issues/1839
# fzf uses find by default
export FZF_DEFAULT_COMMAND='fd --type f --exclude .git --follow --hidden'

# zoxide
# zoxide doesnt read from $FZF_DEFAULT_OPTS by default
export _ZO_FZF_OPTS="$FZF_DEFAULT_OPTS"

# source ~/dev/shell/scripts/fzf-wiki-examples-using.zsh


tmuxit() {
echo $1
result=$(
ls | fzf --ansi
)
cd $result
}



lspci-vga() {
lspci -v | grep -A 10 -E "(VGA|3D)"
}

# in every rtp all files in /plugin get sourced at launch
# nvim-dropdown /lua folder is a symlink to main config
# anything within /lua rtp can be required by lua require""
# packer output install path also has to be by rtp
# TODO: optionally install plugins for dropdown straight into ~/dot/nvim-dropdown and .gitignore
# TODO: try set rtp in init.lua without shell wrappers for dropdown and test
#--cmd "set rtp+=$HOME/tmp/nvim-tmp/pack/*/start/*" \
nvd() {
  nvim --clean \
    --cmd "set rtp+=$HOME/dot/nvim-dropdown" \
    --cmd "set rtp+=$HOME/tmp/nvim-dropdown/start/*" \
    -u ~/dot/nvim-dropdown/init.lua
}

nvt() {
  nvim --clean \
    --cmd "set rtp+=$HOME/dot/nvim-test" \
    --cmd "set rtp+=$HOME/tmp/nvim-test/start/*" \
    -u ~/dot/nvim-test/init.lua
}


audio_set_default_out() {
index=$(pamixer --list-sinks | fzf | awk '{print $1}')
pacmd set-default-sink $index
}



# keep last
source /home/f1/.zplug/repos/zsh-users/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

autoscript() {
  touch $1 && chmod +x $1 && nvim $1
}

# https://serverfault.com/questions/77162/how-to-get-pgrep-to-display-full-process-info
function pgrep() { /usr/bin/pgrep "$@" | xargs --no-run-if-empty ps fp; }

function testjson() {
    # set val (pikaur --query --sysupgrade --aur 2>/dev/null | wc --lines)
    # if test $val -eq 0
        # echo "{\"state\": \"Idle\", \"text\": \"AUR asd\"}"
    # else
        echo "{\"state\": \"Warning\", \"text\": \"AUR asd2\"}"
    # end
}


# function howdoi() {
  # source 
# }


function src() {
  export SRC_ENDPOINT=http://localhost:7080
  export SRC_ACCESS_TOKEN=$(pass show src/graphql-pat)
  /usr/bin/src $@
}


# BROOT
source /home/f1/.config/broot/launcher/bash/br

# deep fuzzy cd
function dcd {
    br --only-folders --cmd "$1;:cd"
}


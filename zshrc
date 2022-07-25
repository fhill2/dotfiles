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



#### OLD


#alias qtilekb='qtile_kb_rofi.sh -c ~/dev/dot/home-manager/config/qtile/config.py'
# doesnt work on nixos - move to nix config
#function nvim() {
# nvim wrapper
# if [[ -v NVIM_LISTEN_ADDRESS ]]; then
#    nvr --servername "$NVIM_LISTEN_ADDRESS" -c "lua vim.api.nvim_set_current_win(require'futil.terminal'.last_editor_winnr)"
#    nvr --servername "$NVIM_LISTEN_ADDRESS" $@
#  else
#    /usr/bin/nvim $@
#  fi
#
#}

# stowth() {
#   stow -vSt ~ $1
# }
#
# unstowth() {
#   stow -vDt ~ $1
# }

#
# turns on less syntax highlighting
#export LESS=' -R '

# export LESSOPEN="|batpipe %s"
# export BATPIPE="color"
# LESS="$LESS -R"
# unset LESSCLOSE



# function xplr() {
#   if [[ -v NVIM_LISTEN_ADDRESS ]]; then
#   export NVIM_XPLR_ROOT=~/.local/share/nvim/site/pack/packer/start/xplr.nvim
#   ~/bin/xplr -C "/home/f1/.local/share/nvim/site/pack/packer/start/xplr.nvim/xplr/init.lua" $@ # ~ isnt supported
#   else
#   ~/bin/xplr $@
#   fi
# }

#luarocks() {
#sudo /usr/bin/luarocks --lua-version=5.1 install $@
#}
#alias lua='lua5.1'
# stow (th stands for target=home)

# qemu wrappers

# qmm() {
# sudo virsh qemu-monitor-command --hmp win10-5 $1
# }
#
# qmga() {
# sudo virsh qemu-agent-command --domain win10-5 --cmd "{\"execute\":\"$1\"}"
# }

# pet

# save previously used command
# petp() {
#   PREV=$(fc -lrn | head -n 1)
#   sh -c "pet new `printf %q "$PREV"`"
# }

# # show fzf with hotkey otherwise pet fails as ZLE isnt active
# pet-select() {
# BUFFER=$(pet search --query "$LBUFFER")
# CURSOR=$#BUFFER
# zle redisplay
# }

# zle -N pet-select
# stty -ixon
# bindkey '^o' pet-select

# tw() {
#   BUFFER=$(the-way search --stdout --languages="sh")
#   print -z $BUFFER
# }

# ghclone() {
#   dir="${3:-$2}"
#   git clone git@github.com:$1/$2.git $dir
#   cd $dir
# }

# flog() {
# log="$(fd --follow --extension 'log' . ~/.local/share/nvim | fzf --exit-0)" || return $?
# tail -f $log
# }

# vagrant(){
#   docker run -it --rm \
#     -e LIBVIRT_DEFAULT_URI \
#     -v /var/run/libvirt/:/var/run/libvirt/ \
#     -v ~/.vagrant.d:/.vagrant.d \
#     -v $(realpath "${PWD}"):${PWD} \
#     -w $(realpath "${PWD}") \
#     --network host \
#     vagrantlibvirt/vagrant-libvirt:edge \
#     vagrant $@
#   }

# f_list_keybinds() {
# f_list_keybinds.py | fzf
# }
# nvd() {
#     if [ -n "$1" ]; then
#       nvim --cmd 'lua load_profile="dropdown"' -c $1
#     else
#       nvim --cmd 'lua load_profile="dropdown"'
#     fi
# }


# nvdd() {
#   nvim -c "lua CLI=true" -c "lua print(CLI)"
# }
#

# sway_get_c_win() {
# swaymsg -t get_tree | jq -r '.. | (.nodes? // empty)[] | if (.focused) then select(.focused) | "\(.rect.x),\(.rect.y) \(.rect.width)x\(.rect.height)" else (.floating_nodes? // empty)[] | select(.visible) | select(.focused) | "\(.rect.x),\(.rect.y) \(.rect.width)x\(.rect.height)" end'
# }

# https://www.reddit.com/r/archlinux/comments/n45j9b/running_a_script_after_the_current_user_has/
# as optimus-manager doesnt install hooks if you arent using a display manager and i want to use  optimus-manager like this:
# optimus-manager --switch nvidia
# optimus-manager --switch intel
# startx() {
#   echo "startx custom function called"
#   if [[ "$HOST" == "arch-lap" ]]; then
#     exec sh -c "startx ; sudo prime-switch"
#   fi


#   if [[ "$HOST" == "arch-desk" ]]; then
#     /usr/bin/startx
#   fi
# }
# https://serverfault.com/questions/77162/how-to-get-pgrep-to-display-full-process-info
function ppgrep() { pgrep "$@" | xargs --no-run-if-empty ps fp; }

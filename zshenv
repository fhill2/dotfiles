# logit() {
# TIMESTAMP=`date "+%Y-%m-%d %H:%M:%S"`
# echo "first argument is $1" >> /home/f1/logs/zsh.log
# echo "$TIMESTAMP second arg is $3" >> /home/f1/logs/zsh.log      
# }

source ~/.profile
#path+=('/home/f1/dev/cl/lua/standalone/run')
#path+=('/home/f1/.cargo/bin')
#path+=/home/f1/bin

#TERMINFO="/home/f1/dev/dot/home-manager/config/kbd/nix/terminfo";
#TERMINFO="/home/f1/.nix-profile/share/terminfo"
#TERM="xterm-kitty";
#path+=("/home/f1/dev/cl/shell/bin")

# using $USER_SITE/usercustomize.py now
#export PYTHONSTARTUP=$HOME/dev/cl/python/standalone/init.py

#GPG_TTY=$(tty)
#export GPG_TTY

export LUA_PATH="/home/f1/dev/cl/lua/standalone/?.lua;/usr/share/nvim/runtime/lua/vim/?.lua;/usr/share/nvim/runtime/lua/vim/?/?.lua;/home/f1/.local/share/nvim/site/pack/packer/start/plenary.nvim/lua/?.lua;/home/f1/.local/share/nvim/site/pack/packer/start/plenary.nvim/lua/?/init.lua;/usr/local/share/lua/5.1/?.lua;./?.lua;/usr/share/lua/5.1/?.lua;/usr/share/lua/5.1/?/init.lua;/usr/lib/lua/5.1/?.lua;/usr/lib/lua/5.1/?/init.lua;/home/f1/.luarocks/share/lua/5.1/?.lua;/home/f1/.luarocks/share/lua/5.1/?/init.lua;/usr/local/share/lua/5.1/?/init.lua"



#/usr/local/share/lua/5.1/?.lua;./?.lua;/usr/share/lua/5.1/?.lua;/usr/share/lua/5.1/?/init.lua;/usr/lib/lua/5.1/?.lua;/usr/lib/lua/5.1/?/init.lua;/home/f1/.luarocks/share/lua/5.1/?.lua;/home/f1/.luarocks/share/lua/5.1/?/init.lua;/usr/local/share/lua/5.1/?/init.lua"

#export LUA_CPATH='./?.so;/usr/lib/lua/5.1/?.so;/usr/lib/lua/5.1/loadall.so;/home/f1/.luarocks/lib/lua/5.1/?.so;/usr/local/lib/lua/5.1/?.so'
export LUA_INIT="@/home/f1/dev/cl/lua/standalone/init.lua"


#export LUA_PATH='/usr/local/share/lua/5.1/?.lua;./?.lua;/usr/share/lua/5.1/?.lua;/usr/share/lua/5.1/?/init.lua;/usr/lib/lua/5.1/?.lua;/usr/lib/lua/5.1/?/init.lua;/home/f1/.luarocks/share/lua/5.1/?.lua;/home/f1/.luarocks/share/lua/5.1/?/init.lua;/usr/local/share/lua/5.1/?/init.lua'
export LUA_CPATH='./?.so;/usr/lib/lua/5.1/?.so;/usr/lib/lua/5.1/loadall.so;/home/f1/.luarocks/lib/lua/5.1/?.so;/usr/local/lib/lua/5.1/?.so'


source ~/dev/cl/shell/zsh-src/telescope.zsh

function logit () {
TIMESTAMP=`date "+%Y-%m-%d %H:%M:%S"`
  # shellcheck disable=SC2154  # undeclared zsh variables in bash
  if [[ $BASH_VERSION ]]; then
    local file=${BASH_SOURCE[1]##*/} func=${FUNCNAME[1]} line=${BASH_LINENO[0]}
  else  # zsh
    emulate -L zsh  # because we may be sourced by zsh `emulate bash -c`
    # $funcfiletrace has format:  file:line
    local file=${funcfiletrace[1]%:*} line=${funcfiletrace[1]##*:}
    local func=${funcstack[2]}
    [[ $func =~ / ]] && func=source  # $func may be filename. Use bash behaviour
  fi
  echo "${TIMESTAMP}:${file##*/}:$func:$line $*" >> /home/f1/logs/zsh.log
}


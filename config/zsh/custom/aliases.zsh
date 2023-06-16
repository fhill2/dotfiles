alias rm=trash
alias ls='ls --color'
alias lua='lua5.1'
alias nv='nvim'
alias serve='python3 -m http.server'
alias mysql='mysql -u root -p'
alias alsa-info='alsa-info.sh'
alias less='less -r'
alias l='ls -al'


get_identifier() {
codesign -dv --verbose=4 "$1" | grep Identifier
}

# deep fuzzy cd
function dcd {
    br --only-folders --cmd "$1;:cd"
}


autoscript() {
  touch $1 && chmod +x $1 && nvim $1
}

# https://serverfault.com/questions/77162/how-to-get-pgrep-to-display-full-process-info
function pgrep() { /usr/bin/pgrep "$@" | xargs --no-run-if-empty ps fp; }



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

ghcb() {
  git clone --bare git@github.com:$1
}

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

function prev() {
  PREV=$(fc -lrn | head -n 1)
  sh -c "pet new `printf %q "$PREV"`"
}

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

autoload -U compinit
zmodload -i zsh/complist
compinit # loads compdef function etc



zstyle ':completion*:default' menu 'select=1' # needed for highlighting the current result in dropdown menu







ZLS_COLORS="no=00:fi=00:di=01;34:ln=01;36:\
  pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:\
  or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:\
  *.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:\
  *.z=01;31:*.Z=01;31:*.gz=01;31:*.deb=01;31:\
  *.jpg=01;35:*.gif=01;35:*.bmp=01;35:*.ppm=01;35:\
  *.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:\
  *.mpg=01;37:*.avi=01;37:*.gl=01;37:*.dl=01;37:"


emulate -L zsh -o extendedglob

bindkey -M menuselect '^j' accept-and-menu-complete
bindkey -M menuselect '^h' read-command


zstyle ':completion:*' format '%S%d%s'


# group names become the name of the matching tag
zstyle ':completion:*' group-name ''




bindkey '^Xa' all-matches
zstyle ':completion:all-matches:*' old-matches only





zle -C _my_completions complete-word _generic


# fixing old comp not showing feedbac
# zstyle -e ':completion:*:*:-command-:*' completer _my_completions
zstyle -e ':completion:*' completer _my_completions

# zstyle -e ':completion:*' completer _autocomplete.config.completer
# _autocomplete.config.completer() {
#   reply=( _complete ); [[ -z $BUFFER ]] ||
#     reply=(
#       _expand _complete _correct
#       _autocomplete.ancestor_dirs _autocomplete.recent_paths
#       _history _complete:-fuzzy _ignored
#       _my_completions
#     )
# }


_complete_files () {

#local name nopt xopt format gname hidden hide match opts tag
#logit "$name $nopt $xopt $format $gname $hidden $hide $match $opts $tag"
#logit "$compstate[list]"
#logit "$_comp_setup"
#logit "$_lastcomp"
#logit "$compstate"

logit "================================================"

for key val in "${(@kv)_lastcomp}"; do
    logit "$key -> $val"
done


for key val in "${(@kv)_compstate}"; do
    logit "$key -> $val"
done


if [[ ${_lastcomp[completer]} == 'my-completions' ]]; then
logit 'match is in my-completions'
if [[ ${_lastcomp[nmatches]} -gt 1  ]]; then
logit "matches greater than 1"
else
logit "matches less than 1"
fi
fi

#  logit ${compstate[insert]}
 # _main_complete _files
}
compdef -k _complete_files complete-word _my_completions '^Y'
# complete-word


function _my_Init() {
    
}


function _my_arg_completions() {
# logit "this was called"
}

function _my_completions() {
#logit "custom completion main func trigerred"
# logit "curcontext is $curcontext"

  local -a snippets
  snippets=('ls -a -l:desc1' 
'ls -p -r:desc' 
'ls -a -r:desc' 
'ls -n -p:desc' 
'docker container list: show containers' 
'docker run tjdevries:run tjdevries container')

# logit "current is $CURRENT"

# main filter here: nothing passes this point that doesnt match prompt (starts with)
local -a snippets2

for i in "${snippets[@]}"
do
startswith="$words"
if [[ $i = ${startswith}* ]]; then
# logit "$i"
    snippets2+=`echo "$i"`
fi

done

#logit "$snippets2"


 if [[ $CURRENT -gt 1 ]]; then
#logit 'greater than picked'


local -a snippets3

for i in "${snippets[@]}"
do
 snippets3+=`echo "$i" | cut -d " " -f2-`
 done

 _describe -t 'snippetsasd' 'snippets' snippets3

else
# logit 'less than picked'
        
 _describe -t 'snippetsasd' 'snippets' snippets2
    fi


# for key val in "${(@kv)_lastcomp}"; do
#     logit "$key -> $val"
# done
}


function .runAfter() {
#logit "my custom completion .runafter() trigerred"
#echo "runAfter trig" >> /home/f1/log2.txt
}

_my_Init
compdef _my_completions
add-zsh-hook preexec .runAfter


# this puts snippets always at top above all other results
#
zstyle ':completion:*' group-order 'snippetsasd' 'Executables' 'Builtins' 'Commands' 'Aliases' 'Functions' 'Variables' 'Keywords'



#compdef -command-
compinit # loads compdef function etc
emulate -L zsh -o extendedglob


zstyle ':completion*:default' menu 'select=1' # needed for highlighting the current result in dropdown menu


zstyle ':completion:*' format '%S%d%s'

# group names become the name of the matching tag
zstyle ':completion:*' group-name ''

zstyle -e ':completion:*' completer _my_completions





#compdef _my_completions -first-
zstyle ':completion:*' completer _my_completions _complete
add-zsh-hook preexec .runAfter


# this puts snippets always at top above all other results
#
zstyle ':completion:*' group-order 'snippets' 'Executables' 'Builtins' 'Commands' 'Aliases' 'Functions' 'Variables' 'Keywords'

# dont group items with the same description together
zstyle ':completion:*' list-grouped off








function _my_completions_init() {
#logit "MY INIT TRIG"
}



text_to_add() {
BUFFER=${BUFFER//\\/}
}









zle -N self-insert-completion
bindkey ' ' self-insert-completion


self-insert-completion() {
logit "self insert trig"
# TODO: this could potentially mess with other info on the prompt. 
# if this is the case: save completion output to global variable, only search replace if prompt = item in global variable





if [[ $LASTWIDGET == "menu-select" ]]; then
# if [[ $BUFFER =~ '^\w*\\' ]]; then
# if string starts with WORD\ space
#    logit "TEXT TO ADD TRIG"
    zle -N text_to_add
    zle text_to_add
# fi
else
zle self-insert
fi
}





_my_completions() {
#logit "_my_completions called"



#logit "================================================="
snippetFile=$(cat -s /home/f1/code/nvim-configs/nvim-main/ultisnips/zsh.snippets | awk -v ORS='\\n' 1)

snippetFile=${snippetFile//\\n\\n/\\n} # remove empty lines

getsnippets=(${(s/endsnippet\n/)snippetFile}) # split string by delimiter 'endsnippet'
local -a snippets

for i in "${getsnippets[@]}"; do
getdescbody=(${(s/\n/)i}) # split string by delimiter '\n'
getdesc=${getdescbody[1]}
getdesc=$(echo $getdesc | cut -d '"' -f2)
getbody=${getdescbody[2]}
snippets+="${getbody}:${getdesc}"
done

# ============ GET COMPLETIONS ABOVE HERE =================

# main filter here: nothing passes this point that doesnt match prompt (starts with)
local -a snippets2

for i in "${snippets[@]}"
do
startswith="$words"
if [[ $i = ${startswith}* ]]; then
# logit "$i"
    snippets2+=`echo "$i" | cut -d " " -f${CURRENT}-`
fi

done

#logit ${snippets2[@]}
_describe -t "Ultisnips" "snippets" snippets2


# send to tmux floating window


return 1
}


function .runAfter() {
#logit "my custom completion .runafter() trigerred"
}


_my_completions_init # run init function at zsh startup/reload

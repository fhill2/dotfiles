

tmx1() {
# run on snippet fzf window


# save a pane id to a shell variable
tui_snippets=$(tmux display-message -p "#{pane_id}")

# now save the shell variable to tmux user option (user options are prefixed with @)
tmux set -g @tui_snippets "$tui_snippets"


}


# tmx2() {
# tui_snippets="$(tmux show -g @tui_snippets)"
# tui_snippets=${tui_snippets//@tui_snippets /}

# }


# copy-win32yank() {
# clipboard=$(win32yank.exe -o)
# RBUFFER=${clipboard}

# autoload -Uz end-of-line
# zle -N end-of-line
# #zle-end-of-line
# #echo $clipboard
# }

# zle -N copy-win32yank
# bindkey "^[[v" copy-win32yank

skrga() {
    local file
    file="$(sk-tmux --bind "ctrl-p:toggle-preview" --ansi -i --cmd-query "$*" -c 'rga --ignore-case --color=always --line-number --column {}' --preview 'bat --color=always --style=header,numbers --highlight-line "$(echo {1}|cut -d: -f2)" --line-range "$(($(echo {1}|cut -d: -f2))):$(($(echo {1}|cut -d: -f2)+50))" "$(echo {1}|cut -d: -f1)"')"; [[ $? -eq 0 ]] && echo "opening $file" && subl "$(echo "$file"|cut -d: -f1):$(echo "$file"|cut -d: -f2):$(echo "$file"|cut -d: -f3)" || return 1;
}

fif() {
  if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
  rg --files-with-matches --no-messages "$1" | fzf --preview "highlight -O ansi -l {} 2> /dev/null | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' || rg --ignore-case --pretty --context 10 '$1' {}"
}



des() {
#echo "function ran"
#find /tmp -maxdepth 1 -mindepth 1 -type f -name 'nvim*.vim' | xargs rm -f

find /home/f1/.config/nvim/lua/futil/state -maxdepth 1 -mindepth 1 -type f -name '*' | xargs rm -f


}



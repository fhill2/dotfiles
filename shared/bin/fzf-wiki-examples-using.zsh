

#https://github.com/phiresky/ripgrep-all
f_fzf_rga() {
rg_prefix="rga --files-with-matches"
local file
#fzf --sort --preview="[[ ! -z {} ]] && rga --pretty --context 5 {q} {}" \
file="$(
fzf_default_command="$rg_prefix '$1'" \
  fzf --sort --preview="[[ ! -z {} ]] && nvimpager -p {}" \
  --preview-window="70%:wrap"
  )" &&
    echo "opening $file" &&
    xdg-open "$file"
  }

#--bind "change:reload:$RG_PREFIX {q}" \
#--phony -q "$1" \


# Modified version where you can press
#   - CTRL-O to open with `open` command,
#   - CTRL-E or Enter key to open with the $EDITOR
fo() {
  IFS=$'\n' out=("$(fzf-tmux --query="$1" --exit-0 --expect=ctrl-o,ctrl-e)")
  key=$(head -1 <<< "$out")
  file=$(head -2 <<< "$out" | tail -1)
  if [ -n "$file" ]; then
    [ "$key" = ctrl-o ] && open "$file" || ${EDITOR:-vim} "$file"
  fi
}
####### END WORKFLOW 3-4: opening files


######## WORKFLOW 1: file move / copy
### MAYBE - HAVE POTENTIAL
### type: f mv ENTER
### select files
### enter
f() {
  sels=( "${(@f)$(fd "${fd_default[@]}" "${@:2}"| fzf)}" )
  test -n "$sels" && print -z -- "$1 ${sels[@]:q:q}"
}


# Like f, but not recursive.
fm() f "$@" --max-depth 1





# Deps
alias fz="fzf-noempty --bind 'tab:toggle,shift-tab:toggle+beginning-of-line+kill-line,ctrl-j:toggle+beginning-of-line+kill-line,ctrl-t:top' --color=light -1 -m"
fzf-noempty () {
local in="$(</dev/stdin)"
test -z "$in" && (
exit 130
) || {
  ec "$in" | fzf "$@"
}
}
ec () {
  if [[ -n $ZSH_VERSION ]]
  then
    print -r -- "$@"
  else
    echo -E -- "$@"
  fi
}

######## END WORKFLOW 3-4: file move / copy





# fzf
export FZF_DEFAULT_OPTS='--no-height --layout=reverse --border'
export FZF_TMUX=1

#https://github.com/junegunn/fzf/issues/1839
# fzf uses find by default
export FZF_DEFAULT_COMMAND='fd --type f --exclude .git --follow --hidden'

#https://archive.zhimingwang.org/blog/2015-09-21-zsh-51-and-bracketed-paste.html
# zle_bracketed_paste is causing spam when launching fzf function
unset zle_bracketed_paste


# Modified version where you can press
#   - CTRL-O to open with `open` command,
#   - CTRL-E or Enter key to open with the $EDITOR
fo() {
  IFS=$'\n' out=("$(fzf-tmux --query="$1" --exit-0 --expect=ctrl-o,ctrl-e)")
  echo "$out"
  key=$(head -1 <<< "$out")
  file=$(head -2 <<< "$out" | tail -1)
  # if [ -n "$file" ]; then
  #   [ "$key" = ctrl-o ] && open "$file" || ${EDITOR:-vim} "$file"
  # f
}


f_fzf() {
  #https://github.com/junegunn/fzf/blob/master/ADVANCED.md#using-fzf-as-interative-ripgrep-launcher

if "$1" == "fd"; then
  CMD_PREFIX="fd -l"
  PROMPT="fd"
elif "$1" == "fd_1"; then
  CMD_PREFIX="fd -l --maxdepth 1"
  PROMPT="fd_1"
elif "$1" == "files"; then
  CMD_PREFIX="fd -l --type f"
  PROMPT="files"
elif "$1" == "dir"; then
  CMD_PREFIX="fd -l --type d"
  PROMPT="dir"
elif "$1" == "rg"; then
  CMD_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
  PROMPT="rg"
fi


# case $1 in
#   fd)
#     CMD_PREFIX="fd -l"
#     PROMPT="fd"
#     ;;

#   fd_1)
#     CMD_PREFIX="fd -l --maxdepth 1"
#     PROMPT="fd_1"
#     ;;

#   "files")
#     CMD_PREFIX="fd -l --type f"
#     PROMPT="files"
#     ;;

#   "dir")
#     CMD_PREFIX="fd -l --type d"
#     PROMPT="dir"
#     ;;

#   "rg")
#     CMD_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
#     PROMPT="rg"
#     ;;

#   *)
#     echo "specify fd,fd_1,dir,rg"
#     ;;
# esac


if [ -z "$1" ]; then
  return
fi

#INITIAL_QUERY="${*:-}"
INITIAL_QUERY=""

# FZF_DEFAULT_COMMAND="$CMD_PREFIX $(printf %q "$INITIAL_QUERY") | f_fd_add_col.py" \
export FZF_DEFAULT_COMMAND="fd -l"
#result=$(
# fzf --ansi \
#   --height 100% \
#   --border bottom \
#   --color "hl:-1:underline,hl+:-1:underline:reverse" \
#   --disabled \
#   --bind "change:reload:sleep 0.1; $FZF_DEFAULT_COMMAND {q} | calculate frecency_score || true" \
#   --bind "alt-enter:unbind(change,alt-enter)+change-prompt(2. fzf> )+enable-search+clear-query" \
#   --prompt "1. $PROMPT> " \
#   --delimiter : \
#   --preview "f_nvimpager {1} {2}" \
#   --preview-window 'right,50%,noborder'
# fzf
# )

# case EXPRESSION in

#   PATTERN_1)
#     STATEMENTS
#     ;;

#   PATTERN_2)
  #     STATEMENTS
  #     ;;

#   PATTERN_N)
  #     STATEMENTS
  #     ;;

#   *)
  #     STATEMENTS
  #     ;;
  # esac


#setopt shwordsplit
# IFS=':'
# selected=(${result})
# [ -n "${selected[1]}" ] && nvim "${selected[1]}" "+${selected[2]}"


}

f_fzf() {
  export FZF_DEFAULT_COMMAND="fd -l"
  if "$1" == "fd"; then
    CMD_PREFIX="fd -l"
    PROMPT="fd"
  elif "$1" == "fd_1"; then
    CMD_PREFIX="fd -l --maxdepth 1"
    PROMPT="fd_1"
  elif "$1" == "files"; then
    CMD_PREFIX="fd -l --type f"
    PROMPT="files"
  elif "$1" == "dir"; then
    CMD_PREFIX="fd -l --type d"
    PROMPT="dir"
  elif "$1" == "rg"; then
    CMD_PREFIX="rg --column --line-number --no-heading --color=always --smart-case "
    PROMPT="rg"
  fi

}

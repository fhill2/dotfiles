#. ~/zsh/log.sh
#source ~/zsh/log.zsh
#spaceship
SPACESHIP_DIR_TRUNC=0

SPACESHIP_PROMPT_ORDER=(
dir
vi_mode
#git_last_commit # disabled, fatal: this operation must be run in a work tree
#check_remote_change
)


#l "my loggin1234"



SPACESHIP_GIT_LAST_COMMIT_SHOW="${SPACESHIP_GIT_LAST_COMMIT_SHOW=true}"
SPACESHIP_GIT_LAST_COMMIT_SYMBOL="${SPACESHIP_GIT_LAST_COMMIT_SYMBOL=""}"
SPACESHIP_GIT_LAST_COMMIT_PREFIX="${SPACESHIP_GIT_LAST_COMMIT_PREFIX="("}"
SPACESHIP_GIT_LAST_COMMIT_SUFFIX="${SPACESHIP_GIT_LAST_COMMIT_SUFFIX=") "}"
SPACESHIP_GIT_LAST_COMMIT_COLOR="${SPACESHIP_GIT_LAST_COMMIT_COLOR="magenta"}"

# ------------------------------------------------------------------------------
# Section
# ------------------------------------------------------------------------------


# Show git_last_commit status
# spaceship_ prefix before section's name is required!
# Otherwise this section won't be loaded.
spaceship_git_last_commit() {
  # If SPACESHIP_GIT_LAST_COMMIT_SHOW is false, don't show git_last_commit section
  [[ $SPACESHIP_GIT_LAST_COMMIT_SHOW == false ]] && return

  spaceship::is_git || return

  local 'git_last_commit_status'
  git_last_commit_status=$(git log --pretty='format:%s|%cr' "HEAD^..HEAD" 2>/dev/null | head -n 1)

  # Exit section if variable is empty
  [[ -z $git_last_commit_status ]] && return

  # Display git_last_commit section
  spaceship::section \
    "$SPACESHIP_GIT_LAST_COMMIT_COLOR" \
    "$SPACESHIP_GIT_LAST_COMMIT_PREFIX" \
    "$SPACESHIP_GIT_LAST_COMMIT_SYMBOL$git_last_commit_status" \
    "$SPACESHIP_GIT_LAST_COMMIT_SUFFIX"

}



SPACESHIP_CHECK_REMOTE_CHANGE_SHOW="${SPACESHIP_GIT_LAST_COMMIT_SHOW=true}"
SPACESHIP_CHECK_REMOTE_CHANGE_SYMBOL="${SPACESHIP_GIT_LAST_COMMIT_SYMBOL=""}"
SPACESHIP_CHECK_REMOTE_CHANGE_PREFIX="${SPACESHIP_GIT_LAST_COMMIT_PREFIX="("}"
SPACESHIP_CHECK_REMOTE_CHANGE_SUFFIX="${SPACESHIP_GIT_LAST_COMMIT_SUFFIX=") "}"
SPACESHIP_CHECK_REMOTE_CHANGE_COLOR="${SPACESHIP_GIT_LAST_COMMIT_COLOR="magenta"}"


# check_remote_change() {

    
# }


#spaceship_check_remote_change() {
#    l "this trigerred"


#  spaceship::is_git || return

#  local 'check_remote_change'
#  local GITREMOTE GITREMOTESTATUS
#  # check_remote_change=$(check_remote_change)




#GITREMOTE=$(git remote show origin 2>/dev/null)
#    GITREMOTESTATUS=$(echo "$GITREMOTE" | grep -oP '\(\K[^\)]+' 2> /dev/null)
#    l $GITREMOTESTATUS

#  if [[ -z $GITREMOTESTATUS ]]; then return; fi
   

#   if [ $GITREMOTESTATUS = "up to date" ]; then
#        check_remote_change="UpToDate"
#SPACESHIP_CHECK_REMOTE_CHANGE_COLOR="green"
#    elif [ $GITREMOTESTATUS = "local out of date" ]; then
#        check_remote_change="LocalOutOfDate"
#SPACESHIP_CHECK_REMOTE_CHANGE_COLOR="red"
#    else 
#        check_remote_change="Error"
#SPACESHIP_CHECK_REMOTE_CHANGE_COLOR="red"
#    fi









#  l $check_remote_change
#  # Exit section if variable is empty
#  #[[ -z $git ]] && return

#  l "got here f"
#  # Display git_last_commit section
#  spaceship::section \
#    "$SPACESHIP_CHECK_REMOTE_CHANGE_COLOR" \
#    "$SPACESHIP_CHECK_REMOTE_CHANGE_PREFIX" \
#    "$SPACESHIP_CHECK_REMOTE_CHANGE_SYMBOL$check_remote_change" \
#    "$SPACESHIP_CHECK_REMOTE_CHANGE_SUFFIX"

#}


# ------------------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------------------

SPACESHIP_VI_MODE_SHOW="${SPACESHIP_VI_MODE_SHOW=true}"
SPACESHIP_VI_MODE_PREFIX="${SPACESHIP_VI_MODE_PREFIX=""}"
SPACESHIP_VI_MODE_SUFFIX="${SPACESHIP_VI_MODE_SUFFIX="$SPACESHIP_PROMPT_DEFAULT_SUFFIX"}"
SPACESHIP_VI_MODE_INSERT="${SPACESHIP_VI_MODE_INSERT="[I]"}"
SPACESHIP_VI_MODE_NORMAL="${SPACESHIP_VI_MODE_NORMAL="[N]"}"

SPACESHIP_VI_MODE_INSERT_COLOR="${SPACESHIP_VI_MODE_INSERT_COLOR="green"}"
SPACESHIP_VI_MODE_NORMAL_COLOR="${SPACESHIP_VI_MODE_NORMAL_COLOR="blue"}"

# ------------------------------------------------------------------------------
# Section
# ------------------------------------------------------------------------------

# Show current vi-mode mode
spaceship_vi_mode() {
  [[ $SPACESHIP_VI_MODE_SHOW == true ]] || return

  if bindkey | grep "vi-quoted-insert" > /dev/null 2>&1; then # check if vi-mode enabled
    local mode_indicator="${SPACESHIP_VI_MODE_INSERT}"

    case "${KEYMAP}" in
      main|viins)
      mode_indicator="${SPACESHIP_VI_MODE_INSERT}"
      color="${SPACESHIP_VI_MODE_INSERT_COLOR}"
      ;;
      vicmd)
      mode_indicator="${SPACESHIP_VI_MODE_NORMAL}"
      color="${SPACESHIP_VI_MODE_NORMAL_COLOR}"
      ;;
    esac

    spaceship::section \
      "$color" \
      "$SPACESHIP_VI_MODE_PREFIX" \
      "$mode_indicator" \
      "$SPACESHIP_VI_MODE_SUFFIX"
  fi
}

# ------------------------------------------------------------------------------
# Helpers
# ------------------------------------------------------------------------------

# Temporarily switch to vi-mode
# #spaceship_vi_mode_enable() {
#   function zle-keymap-select() { zle reset-prompt ; zle -R }
#   zle -N zle-keymap-select
#   bindkey -v
# #}


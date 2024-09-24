#!/usr/bin/env bash

# F OCT 2022:
# THIS DOESNT REALLY WORK - FOCUSING ISSUE - USE i3_PISTOL_PREVIEW.SH

# CONTAINER_XID = parent container - all windows held inside this
# GHOST CONTAINER - used to prevent i3 closing the parent container when there are no windows left
# TABBED_CONTAINER_XID - mpv and zathura windows are held inside this window

# get the state of the preview container

# TODO:
# currently tabbed and kitty windows are wrapped with i3_open_wait that execs them
# this would be nicer if they are as subprocesses so killing the i3_pistol_preview.sh main PID closes all previewer windows
# this could also be benefecial - as I can leave the windows open and toggle the previewer window (the previewer windows stay open until I decide they shouldnt be)
# so far only zathura and mpv are child processes
# the script would have to be edited to not kill tabbed / kitty when killing child processes on each new path sent to previewer

# also - script is setup to run as a daemon and constantly accept input from a pipe, this requires a partner script
# this is by choice, to help debugging
# this is different to preview_tui, preview_tabbed - which launch, and accept input from 1 reader until the reader sends EOF, then preview_tabbed|tui close

string_contains() {
    haystack="${1}"
    needle="${2}"

    case $haystack in
        *$needle*)
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

get_status() {
  echo "get status"
# all window nodes inside preview container from get_tree
CONTAINER=$(swaymsg -t get_tree | jq -r '.. | (.nodes? // empty)[] | select(IN(.marks[]; "preview_container"))')
# all classes existing within the preview container
IN_CONTAINER=$(echo "$CONTAINER" | jq -r '.nodes[] | .window_properties.class')
CONTAINER_XID=$(echo "$CONTAINER" | jq -r '.id')
TABBED_CONTAINER_XID=$(echo "$CONTAINER" | jq -r '.nodes[] | select(.window_properties.class == "tabbed") | .window')
KITTY_XID=$(echo "$CONTAINER" | jq -r '.nodes[] | select(.window_properties.class == "kitty") | .window')
VISIBLE_MARKS=$(sway_print_tree  all_visible_windows_on_visible_workspaces | jq -r ".marks | .[]")
}


refocus() {
# xdotool used here instead of as xdotool waits until zathura/mpv is launched, before focusing back to the preview main window
   # this does not happen with swaymsg as mpv and zathura is launched without being wrapped in i3_open_wait.py
   # mpv and zathura is not wrapped with i3_open_wait.py as this uses exec, so child processes cannot be killed using kill $(jobs -p)
   # TODO: create i3_open_wait.py that does not exec, and keeps the processes as a child process
   # this would mean this script becomes sway compatible
   # TODO: or a better solution would be to listen to i3 events and switch focus back dependant on events
   # swaymsg "[con_mark=preview_main] focus"

  # echo "KITTY XID: $KITY_XID"
  # echo "TABBED_CONTAINER_XID: $TABBED_CONTAINER_XID"
   ACTIVE_XID="$(xdotool getactivewindow)"
           if [ $((ACTIVE_XID == $1)) -ne 0 ] ; then
               xdotool windowactivate "$MAINWINDOW"
               echo "xdotool single"
           else
             echo "timeout xdotool $1"
               timeout 2 xdotool behave "$1" focus windowactivate "$MAINWINDOW" &
           fi
}


preview_file() {
# $1 =bin / cmd
# $2 = abs
case $1 in
    mpv)
    mpv --force-window=immediate --loop-file --wid="$TABBED_CONTAINER_XID" "$2" &
      ;;
    zathura)
    zathura -e "$TABBED_CONTAINER_XID" "$2" &
      ;;
    kitty)
    echo "$2" > $PREVIEW_TERMINAL_FIFO
      ;;
  esac

}

preview() {
  # creates either kitty terminal or suckless tabbed window
  # if the window is the first to launch, it also creates a parent i3 container and marks it
  # $1=kitty|tabbed -> classname of the window
  # $2=bin / cmd
  # $3 = abs
  
  
  get_status
  

  # if preview container does not exist
  if [ -z "$CONTAINER_XID" ]; then
    swaymsg "mark preview_main; splith"
    MAINWINDOW="$(xdotool getactivewindow)"
  fi

  if ! string_contains "$IN_CONTAINER" "$1"; then
        echo "OPENING TABBED OR KITTY WINDOW"
        [ -n "$CONTAINER_XID" ] && swaymsg "[con_mark=preview_container] focus; focus child" 
        [ "$1" == "tabbed" ] && TABBED_CONTAINER_XID=$(i3_open_wait.py tabbed)
        [ "$1" == "kitty" ] && KITTY_XID=$(i3_open_wait.py kitty sh -c "i3_preview_terminal.sh")
        echo "KITTY_XID at PREVIEW: $KITTY_XID"
        swaymsg "mark preview_$1"
        [ -z "$CONTAINER_XID" ] && swaymsg "splith; layout tabbed; focus parent; mark preview_container"
        preview_file $2 "$3"
        [ "$1" == "tabbed" ] && refocus $TABBED_CONTAINER_XID
        # [ "$1" == "kitty" ] && refocus $KITTY_XID
        [ "$1" == "kitty" ] && swaymsg "[con_mark=preview_main] focus"
  else
    kill $(jobs -p) # kill the last process
    preview_file $2 "$3"
    [ "$1" == "tabbed" ] && refocus $TABBED_CONTAINER_XID
    if [ "$1" == "kitty" ]; then 
      # as kitty might not be visible (the last previewed file could have been for tabbed window (zathura/mpv))
      ! string_contains "$VISIBLE_MARKS" "preview_kitty" && swaymsg "[con_mark=preview_kitty] focus; [con_mark=preview_main] focus"
      # refocus $KITTY_XID
    fi
  fi


}


handle_mime() {
  echo "========== START =========="

! string_contains "$1" "$HOME" && return # absolute path check




# choose the correct app / bin dependant on mime type
mimetype="$(file -bL --mime-type -- "$1")"
ext="${1##*.}"
[ -n "$ext" ] && ext="$(printf "%s" "${ext}" | tr '[:upper:]' '[:lower:]')"
case "$mimetype" in
    video/*|audio/*)
      preview tabbed mpv "$1"
      # this commands focus the tabbed container
      # refocus
    ;;
    */*office*|*/*document*|application/pdf)
      preview tabbed zathura "$1"
      # this commands focus the tabbed container
      # refocus
    ;;
    *)
      # swaymsg '[con_mark=preview_ghost] focus'
      preview kitty "$1"
    ;;
  esac
  echo "end preview"
}

PREVIEW_FIFO="$HOME/tmp/preview.fifo"
if [ ! -p $PREVIEW_FIFO ]; then
  mkfifo $PREVIEW_FIFO
fi
PREVIEW_TERMINAL_FIFO="$HOME/tmp/preview_terminal.fifo"
if [ ! -p $PREVIEW_TERMINAL_FIFO ]; then
  mkfifo $PREVIEW_TERMINAL_FIFO
fi


while read -r line <"$PREVIEW_FIFO"; do
       if [ -n "$line" ]; then handle_mime $line; fi
done






# ensure_tabbed_container() {
#  # if tabbed window doesnt exist yet, then create it 
#  if [ -z "$TABBED_CONTAINER_XID" ]; then
#    TABBED_CONTAINER_XID=$(i3_open_wait.py tabbed)
#  echo "TABBED_CONTAINER_XID: $TABBED_CONTAINER_XID"
#  swaymsg "[con_id=$TABBED_CONTAINER_XID] move container to mark preview_container"
#  fi
#  # move window to mark here
# }

# create_new_container() {
#   # $1=bin,$2=abs
#     # swaymsg 'splith; layout tabbed; focus parent; mark preview_main'
#   # w="$(i3-msg open)"
#   # w="${w//[^0-9]/}"
#   # swaymsg "[con_id=$w] floating disable, mark preview_container"
#   
#   # open a dummy terminal to avoid i3 closing the parent when killing windows
#   swaymsg "splith"
#   i3gw "preview_ghost"
#   sleep 1
#   swaymsg "splith; layout tabbed; focus parent; mark preview_container"
# }

# open_or_replace_in_container() {
#   # $1=bin,$2=class,$3=abs
#   # get all window classes that exist in the preview_main i3 container
#   # echo "$IN_CONTAINER" "$2"
#   if ! string_contains "$IN_CONTAINER" "$2"; then
#    echo "does not exist yet" 
#   else
#     echo "already exists"
#     WINID=$(echo "$CONTAINER" | jq -r ".nodes[] | select(.window_properties.class == \"$2\") | .window" | xargs)
#     echo "WINID: $WINID"
#     swaymsg "[id=$WINID] focus"
#     # i3_deck tabbed
#     # sleep 2
#     i3_open_wait.py "$1" "$3"
#     # swaymsg "swap container with mark $1"
#     # i3_open_wait.py "$1" "$3"
#     # sleep 2
#     swaymsg "[id=$WINID] kill"
#   fi
#
# }
#
#
# bin_to_class() {
#   [ "$1" == "zathura" ] && echo "Zathura"
#   [ "$1" == "vlc" ] && echo "vlc"
# }


# echo "OPEN OR REPLACE IN CONTAINER"
# open_or_replace_in_container "$BIN" "$1"
# fi

# swaymsg "[con_mark=preview_main] focus"




# how to use with zathura:
# open tabbed container
# use xdotool to window reparent new zathura window into tabbed window
# then either save all XIDs and kill the last zathura window by XID or save PIDs to do it


# spawn tabbed window


# DO THIS 10pm:
# just open tabbed and save window XIC
# then zathura and mpv can open and embed into tabbed container

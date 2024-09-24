#!/usr/bin/env sh

PAGER="${PAGER:-less -P?n -R}"
pidkill() { [ -f "$1" ] && kill "$(cat "$1")" >/dev/null 2>&1 ;}
preview() {
pidkill "$LASTPID"
clear
(pistol "$1" | $PAGER &)
LASTPID=$!
# echo "$LASTPID"
}

TMPDIR="$HOME/tmp"
fifo="$TMPDIR/preview_terminal.fifo"
while read -r line <"$fifo"; do
  echo "got here"
  # to debug if child processes get closed properly
  notify-send "$(jobs -p)"
  if [ -n "$line" ]; then 
    preview "$line"
  fi
done

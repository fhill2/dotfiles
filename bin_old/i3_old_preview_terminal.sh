#!/usr/bin/env sh

# this is an preview_tui.sh replacement
# this has partial functionality of preview_tabbed - it only handles terminal preview 
# this displays the file received at the pipe in the terminal
# partner script to i3_preview_daemon.sh

# ========== SETUP ==========
TMPDIR="$HOME/tmp"

create_fifo() {
if [ -p $1 ]; then
  rm -f "$1"
fi
mkfifo $1
}

fifo="$TMPDIR/preview_terminal.fifo"
pfifo="$TMPDIR/preview_terminal_pager.fifo"
trap "rm -f $fifo" EXIT

create_fifo $fifo
create_fifo $pfifo

PAGER="${PAGER:-less -P?n -R}"

handle_ext() {
ext="${1##*.}"
[ -n "$ext" ] && ext="$(printf "%s" "${ext}" | tr '[:upper:]' '[:lower:]')"
case "$ext" in
gz|bz2) tar -tvf "$1" > "$pfifo" ;;
md) glow -s dark "$1" ;;
7z|a|ace|alz|arc|arj|bz|cab|cpio|deb|jar|lha|lz|lzh|lzma|lzo\
        |rar|rpm|rz|t7z|tar|tbz|tbz2|tgz|tlz|txz|tZ|tzo|war|xpi|xz|Z)
  bsdtar -tvf "$1" > "$pfifo" ;;
htm|html|xhtml) notify-send "html not setup" ;;
*) bat --paging=always "$1" ;; # text
esac
}

pidkill() { [ -f "$1" ] && kill "$(cat "$1")" >/dev/null 2>&1 ;}
# killalljobs() { for pid in $( jobs -p ); do kill -9 $pid ; done ; }

handle_mime() {
  echo "$1"
  echo "$2"
  clear
$PAGER < "$pfifo" &
printf "%s" "$!" > "$PREVIEWPID"

mime="$(file -bL --mime-type -- "$1")"
# exec > "$pfifo"
case "$mime" in
  inode/directory) 
    tree --filelimit "$(find . -maxdepth 1 | wc -l)" -L 3 -C -F --dirsfirst --noreport "$1" > "$pfifo" ;;
  application/octet-stream) mediainfo "$1" > "$pfifo" ;; # binary
  application/zip) unzip -l "$1" > "$pfifo" ;;
  application/font*|application/*opentype|font/*) 
    # fontpreview launches an sxiv window to display the image of the font
    # sleep 2
    swaymsg "[con_mark=preview_container] focus; focus child"
    # sleep 2
    fontpreview "$1" 
    # WINDOW=$(python -c 'from f.i3.window import wait_window; wait_window(cli=True)' | jq -r '.window')
    # notify-send "window here"
    # notify-send "$WINDOW"
    # swaymsg '[con_id=$WINDOW] move container to mark preview_container'

    ;;
  *) handle_ext "$1" ;;
esac
}



preview_fifo() {
while read -r line <"$fifo"; do
  pidkill "$PREVIEWPID"
  # to debug if child processes get closed properly
  notify-send "$(jobs -p)"
  if [ -n "$line" ]; then 
    handle_mime "$line" & 
  fi
done
}

preview_fifo

# font, tar, docx, pdf - not working

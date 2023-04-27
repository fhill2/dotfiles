#!/usr/bin/env sh




PREVIEW_FIFO="$HOME/tmp/preview.fifo"
# PREVIEW_BWIN_FIFO="$HOME/tmp/preview_browser_win.fifo"
PREVIEW_TWIN_FIFO="$HOME/tmp/preview_terminal_win.fifo"

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

# launch_preview_browser() {
#   i3_preview_browser.py & 
# }

preview() {
  echo "preview called - $1 $2"
  swaymsg 'mark preview_main_win'
  SLEEP=0.5
# ( exec pistol "$1")
# MAIN_WIN_ID=$(sway_print_tree focused | jq -r '.window')
MARKS=$(sway_print_tree key marks | jq -r ".[]")
VISIBLE_MARKS=$(sway_print_tree  all_visible_windows_on_visible_workspaces | jq -r ".marks | .[]")

  case $1 in
    browser)
      if ! string_contains "$MARKS" "preview_browser_win"; then
        if string_contains "$MARKS" "preview_terminal_win"; then
          swaymsg "[con_mark=preview_terminal_win] focus; exec i3_deck tabbed"
          firefox-nightly &
        else
          swaymsg "splith"
          firefox-nightly &
        fi
        # TODO: the socketi s not open before i3_preview_browser.py send_message() to it
        sleep 1
        # TODO: subscribe to open window event instead of sleep 
        swaymsg 'mark preview_browser_win'
      fi
      ! string_contains "$VISIBLE_MARKS" "preview_browser_win" && swaymsg '[con_mark=preview_browser_win] focus'
      swaymsg '[con_mark=preview_main_win] focus'
      # echo "$1" > "$PREVIEW_BWIN_FIFO"
      i3_preview_browser.py "file://$2"
      echo "end browser"
    ;;
    terminal)
      if ! string_contains "$MARKS" "preview_terminal_win"; then
        if string_contains "$MARKS" "preview_browser_win"; then
          swaymsg "[con_mark=preview_browser_win] focus; exec i3_deck tabbed; exec kitty zsh -c i3_preview_terminal.sh"
        else
          swaymsg "splith; exec kitty zsh -c i3_preview_terminal.sh"
        fi
        sleep $SLEEP
        swaymsg 'mark preview_terminal_win'
      fi
      echo "$VISIBLE_MARKS"
      ! string_contains "$VISIBLE_MARKS" "preview_terminal_win" && swaymsg '[con_mark=preview_terminal_win] focus'
      swaymsg '[con_mark=preview_main_win] focus'
      echo "$1" > "$PREVIEW_TWIN_FIFO"
      echo "end terminal"
    ;;
  esac

}

handle_ext() {
  # 1=abs,2=mimetype
  ext="${1##*.}"
  [ -n "$ext" ] && ext="$(printf "%s" "${ext}" | tr '[:upper:]' '[:lower:]')"

  # as markdown mime type = text/plain - extension needs to be handled
  case "$ext" in
    md|epub|pdf)
      preview "browser" "$1"
    ;;
    *)
      preview "terminal" "$1"
    ;;
  esac
}

handle_line() {
echo "=============="
  # encoding="$(file -bL --mime-encoding -- "$1")"
  mimetype="$(file -bL --mime-type -- "$1")"

  case "$mimetype" in
    video/*|audio/*|*/*office*|*/*document*)
      preview "browser" "$1"
    ;;
    *)
      handle_ext "$1" "$mimetype"
    ;;
  esac


  # notify-send "$1"
}

[ ! -p "$PREVIEW_FIFO" ] && mkfifo "$PREVIEW_FIFO"
[ ! -p "$PREVIEW_TWIN_FIFO" ] && mkfifo "$PREVIEW_TWIN_FIFO"
# [ ! -p "$PREVIEW_BWIN_FIFO" ] && mkfifo "$PREVIEW_BWIN_FIFO"

while read -r line <"$PREVIEW_FIFO"; do
  if [ -n "$line" ]; then
    handle_line "$line"
  fi
done


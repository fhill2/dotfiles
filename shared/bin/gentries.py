#!/usr/bin/python

# provide a list of all entries with prefixed index
# main gentries script calls this to get the command string, and it is printed then executed by the other script in bash
import sys
entries = [
    { 'title' : "qtile check", 'cmd': "qtile check" },
    { 'title' : "qtile restart", 'cmd': "qtile cmd-obj -o cmd -f restart" }, # yes
    { 'title' : "qtile shutdown", 'cmd': "qtile cmd-obj -o cmd -f shutdown" },
    { 'title' : "qtile - print command list", 'cmd': "qtile cmd-obj -o cmd" },
    { 'title' : "xwininfo -all --> no wm_class", 'cmd': "xwininfo -all" },
    { 'title' : "xprop --> use for qtile - wm_class", 'cmd': "xprop" },
    { 'title' : "qtile - show keybinds", 'cmd' : "qtile cmd-obj -o cmd -f display_kb | python -c 'import sys; print(eval(sys.stdin.read()))' | fzf"},
    { 'title' : "discord - kill all", 'cmd': "sudo pkill -9 Discord" },
    { 'title' : "sync dotbot dotfiles", 'cmd': "cd ~/dot && ./install" },
    { 'title' : "sync repodl", 'cmd': "cd ~/dev/arch/repodl && ./sync" },
]

if len(sys.argv) > 1 and sys.argv[1] == "get_entries":
    for i, entry in enumerate(entries):
        if entry["title"] != "" and entry["cmd"] != "":
          print(str(i) + " " + entry["title"])



if len(sys.argv) > 1 and sys.argv[1].isdigit():
  i = int(sys.argv[1])
  print(entries[i]["cmd"])
  


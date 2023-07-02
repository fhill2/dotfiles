# provide a list of all entries with prefixed index
# main gentries script calls this to get the command string, and it is printed then executed by the other script in bash

def generate_launchctl_restart(plist):
    plist = f'~/Library/LaunchAgents/{plist}.plist'
    return f'launchctl unload {plist} '

import sys
entries = [
    {"title": "restart yabai", "cmd": "plist_restart yabai"},
    {"title": "restart login.sh", "cmd": "plist_restart login.sh"},
    {"title": "skhd - service restart", "cmd": "plist_restart skhd"},
    {"title": "skhd --reload hotkeys", "cmd": "skhd --reload"}
]

if __name__ == "__main__":
    if len(sys.argv) > 1 and sys.argv[1] == "get_entries":
        for i, entry in enumerate(entries):
            if entry["title"] != "" and entry["cmd"] != "":
                print(str(i) + " " + entry["title"])



    if len(sys.argv) > 1 and sys.argv[1].isdigit():
        i = int(sys.argv[1])
        print(entries[i]["cmd"])

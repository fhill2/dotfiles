import sys

PLIST = "$HOME/Library/LaunchAgents"

entries = [
    {"title": "plist_restart yabai", "cmd": "plist_restart yabai"},
    {"title": "launchctl unload yabai", "cmd": f"launchctl unload {PLIST}/yabai.plist"},
    {"title": "launchctl load yabai", "cmd": f"launchctl load {PLIST}/yabai.plist"},
    {"title": "plist_restart login.sh", "cmd": "plist_restart login.sh"},
    {"title": "plist_restart skhd", "cmd": "plist_restart skhd"},
    {"title": "launchctl unload skhd", "cmd": f"launchctl unload {PLIST}/skhd.plist"},
    {"title": "launchctl load skhd", "cmd": f"launchctl load {PLIST}/skhd.plist"},
    {"title": "skhd --reload hotkeys", "cmd": "skhd --reload"},
]

if __name__ == "__main__":
    if len(sys.argv) > 1 and sys.argv[1] == "get_entries":
        for i, entry in enumerate(entries):
            if entry["title"] != "" and entry["cmd"] != "":
                print(str(i) + " " + entry["title"])

    if len(sys.argv) > 1 and sys.argv[1].isdigit():
        i = int(sys.argv[1])
        print(entries[i]["cmd"])

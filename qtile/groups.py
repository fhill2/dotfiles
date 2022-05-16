from libqtile.config import Group, Match

def init_groups():
    #return [Group(i) for i in '1234567890']
    return [
        Group("main1"),
        Group("main2"),
        Group("WIN",
            matches = [
                Match(wm_class = [
                    "looking-glass-client",
                ])
            ]
        ),
        Group("alt1"),
        Group("alt2",
            matches = [
                Match(wm_class = [
                    "Xephyr",
                    #"Virt-manager",
                    ".virt-manager-wrapped",
                    #re.compile("VirtualBox")
                ])
            ]
        ),
        Group("DISC",
            matches = [
                Match(wm_class = [
                    "discord",
                ])
            ]
        ),

    ]

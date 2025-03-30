#!/usr/bin/python
import subprocess, json, pprint, sys



from i3ipc import Connection


# NOT USING THIS ANYMORE


#!/usr/bin/python
def run_sh(cmd):
    output = subprocess.run(cmd, capture_output=True, shell=True)
    return output.stdout.decode('utf-8')
    #.strip().split("\n")

def sanitize(node):
    delete_these_keys = []
    for k in node.keys():
        if k == "fullscreen_mode" or \
            k == "border" or \
            k == "current_border_width" or \
            k == "deco_rect" or \
            k == "geometry" or \
            k == "idle_inhibitors" or \
            k == "inhibit_idle" or \
            k == "max_render_time" or \
            k == "orientation" or \
            k == "percent" or \
            k == "rect" or \
            k == "urgent" or \
            k == "floating_nodes" or \
            k == "focus" or \
            k == "focused" or \
            k == "shell" or \
            k == "window" or \
            k == "sticky" or \
            k == "window_rect":
            delete_these_keys.append(k)

    if "nodes" in node:
        for c in node["nodes"]:
            sanitize(c)
        for c in node["floating_nodes"]:
            sanitize(c)
        node["node_length"] = len(node["nodes"])
        node["znodes"] = node.pop("nodes")

        
    for k in delete_these_keys:
        del node[k]


def print_key(node, match):
    if match in node.keys():
        if node[match] is not None:
            print(node[match])
    if "nodes" in node:
        for c in node["nodes"]:
            print_key(c, match)
        for c in node["floating_nodes"]:
            print_key(c, match)


def find_workspace(tree, index_str):
    for c in tree["nodes"]:
        if "current_workspace" in c.keys():
            if c["current_workspace"] == index_str:
                for cc in c["nodes"]:
                    if cc["name"] == index_str:
                        return cc

                # return c["nodes"]



def get_tree(workspace=True):
    output = run_sh("swaymsg -t get_tree")
    return json.loads("".join(output))


def get_workspace_tree():
    i3 = Connection()
    workspace_index = i3.get_tree().find_focused().workspace().name
    return find_workspace(get_tree(), workspace_index)



if __name__ == '__main__':
    pp = pprint.PrettyPrinter()
    if len(sys.argv) == 2:
        if sys.argv[1] == "sanitize":
            tree = get_workspace_tree()
            sanitize(tree)
            pp.pprint(tree)
        elif sys.argv[1] == "ws" or sys.argv[1] == "workspace":
            pp.pprint(get_workspace_tree())
        else:
            print_key(get_tree(), sys.argv[1])

    else:
        pp.pprint(get_tree())


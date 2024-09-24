#!/usr/bin/python
import json, subprocess
from f.util import colors, run_sh
from os import environ

# for normal terminal colors
# from colorama import Fore, Back, Style
#     return Fore.BLUE + string + Style.RESET_ALL


# def run_sh(cmd):
#     output = subprocess.run(cmd, capture_output=True, shell=True)
#     return output.stdout.decode('utf-8')
#     #.strip().split("\n")


def replace_icons(status):
    matches = {
            "google-chrome": "",
            "kitty": "",
            # "Alacritty": Fore.YELLOW + "" + Style.RESET_ALL
            }

    for match in matches.items():
        # print(match[0], match[1])
        status = status.replace(match[0], match[1]) 
    return status


def is_container(node):
    return len(node["nodes"]) > 0

def is_redundant_container(node):
    # checks to see if the container contains: 1 child only, the only child is a container
    return len(node["nodes"]) == 1 and len(node["nodes"][0]["nodes"]) > 0


def are_all_children_leaves(node):
    for c in node["nodes"]:
        if is_container(c):
            return False
    return True

def are_all_children_non_redundant_containers(node):
    for c in node["nodes"]:
        if is_redundant_container(node): 
            return False
        if not is_container(c):
            return False
    return True
    # 



iter_depth = 0
# TODO: iter depth broken

def print_status(node):
    global iter_depth
    # ported from i3 con.c get_tree_representation with a few changes
    focused = node["focused"]
    container = is_container(node)

    def apply_color_context(string):
        if focused:
            return '<span color="{1}">{0}</span>'.format(string, colors["base0A"]) # yellow

        if container:
            if redundant_container:
                return '<span color="{1}">{0}</span>'.format(string, colors["base08"]) # red 
            else:
                if (iter_depth % 2) == 0: # if even
                    return '<span color="{1}">{0}</span>'.format(string, colors["base0D"]) # blue
                else:
                    return '<span color="{1}">{0}</span>'.format(string, colors["base0C"]) # cyan
        return string

    # if container is a redundant container or not
    # a "redundant" container is a container that holds only 1 child that is of type container)
    # redundant containers are represented as <container layout type>: with no closing character
    # redundant_container = len(node["nodes"]) == 1 and "app_id" in node["nodes"][0]
    redundant_container = is_redundant_container(node)

    if not node["nodes"]:
        if "DISPLAY" in environ:
            return apply_color_context(node["window_properties"]["class"])
        else:
            return apply_color_context(node["app_id"]) # ID = app_id or class

    # container_holding_leaves_only --> a container that holds no other containers
    # represented with no brackets
    container_holding_leaves_only = are_all_children_leaves(node)

    # are_all_children_containers
    # the container holds only other containers
    # if this is true, then spacing will be applied
    # if a container holds containers and windows then no spacing is applied
    container_holding_non_redundant_containers_only = are_all_children_non_redundant_containers(node)

 

    buf = ""
    if redundant_container:
        sep = apply_color_context(": ")
    elif container_holding_leaves_only:
        sep = ""
    elif container_holding_non_redundant_containers_only:
        buf = " "
        sep = apply_color_context("[")
    else: 
        sep = apply_color_context("[")


    if node["layout"] == "splith":
        buf = buf + apply_color_context("H") + sep
    elif node["layout"] == "splitv":
        buf = buf + apply_color_context("V") + sep
    elif node["layout"] == "tabbed":
        buf = buf + apply_color_context("T") + sep
    elif node["layout"] == "stacked":
        buf = buf + apply_color_context("S") + sep

    for [i, c] in enumerate(node["nodes"]):
        if i==0 and container_holding_non_redundant_containers_only:
            buf = buf + " "
        spacer = ""
        if not redundant_container:
            spacer = " " if container_holding_non_redundant_containers_only else ""
        buf = buf + print_status(c) + spacer

    iter_depth = iter_depth + 1

    if redundant_container:
        return buf
    elif container_holding_leaves_only:
        return buf
    elif container_holding_non_redundant_containers_only:
        return buf + apply_color_context("]")
    else:
        return buf + apply_color_context("]")



if __name__ == '__main__':
    # tree["representation"] is the output of con-get_tree_representation i3 or sway - kept here for testing
    # print(replace_icons(tree["representation"]))

    # ignore the workspace root, as sway / i3 as the window root starts at the child of the workspace root
    # window root being the top most level that a window can be placed on the workspace
    output = run_sh("sway_print_tree")
    tree = json.loads("".join(output))[0]
    print(json.dumps({
        # "text": replace_icons(print_status(tree))
        "text": "<span color='#fabd3f'>a</span>"
    }))

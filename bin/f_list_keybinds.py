#!/usr/bin/python
import re
import os
home = os.path.expanduser("~")
f = open(home + "/dev/cl/shell/zsh-src/vi-mode.zsh", "r")



# https://stackoverflow.com/questions/4666973/how-to-extract-the-substring-between-two-markers


# Function which returns last word
def lastWord(string):
    lis = list(string.split(" "))
    length = len(lis)
    return lis[length-1]

maps = []
for line in f:
  line = line.strip()
  if re.match("zvm_bindkey", line):
    map = {}


    if "vicmd" in line:
      map["mode"] = "N" 
    else:
      map["mode"] = "I" 

    keybind = re.findall("'(.+)'", line)[0]
    if ' ' in keybind:
        keybind = keybind.replace(' ', 'space+')
    if '^' in keybind:
        keybind = keybind.replace('^', 'ctrl+')
    map["keybind"] = keybind

    if '#' in line:
      line, comment = line.split('#')
      comment = comment.strip()

    
    line = line.strip()
    map["action"] = lastWord(line)
    map['comment'] = comment
    map["action"] = map["action"].replace('\n', '')
    

    
    maps.append(map) 
    

maps = sorted(maps, key=lambda k: (k['mode']) )
# print
for i, map in enumerate(maps):
  print(map["mode"] + " " + map["keybind"] + " " + map["action"] + " - " + map['comment'])

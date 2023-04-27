#!/usr/bin/python

# LAUNCH THIS SCRIPT WHEN OPENING FZF TAGS - FZF Tag opens ~/tmp/notes-tags
# create filesystem tags and then compare with library tags - compare dicts
# use repodl for reference
# this script creates all tags as symlinks
import os
HOME = os.getenv("HOME")
TAG_DIR = HOME + "/notes-tags"

# create notes-tags folder
# if not os.path.isdir(TAG_DIR):
def mkdir(path):
    try:
        os.mkdir(path, mode = 0o777)
    except:
        pass

def remove_empty_folders():
    dirs = [name for name in os.listdir(TAG_DIR) if os.path.isdir(os.path.join(TAG_DIR, name))]
    for dir in dirs:
        sub = os.path.join(TAG_DIR, dir)
        if not os.listdir(sub):
            os.rmdir(sub)
        

def get_notes(path):
    notes = []
    for root, dirnames, filenames in os.walk(path):
        for filename in filenames:
            if filename.endswith(".norg"):
                notes.append(os.path.join(root, filename))
    return notes

# read tags
# for every note file in notes files, create:
# { 'note_absolute_filepath', ['tag1', 'tag2']}
all_tags = {}
for file in get_notes(NOTES_ROOT):
    f = open(file,'r')
    Lines = f.readlines()
    has_metadata = False
    for line in Lines:
        line = line.strip()
        if not has_metadata and line == "@document.meta":
            has_metadata = True
        elif not has_metadata and line != "@document.meta":
            # if first line is not @document.meta, dont read the file
            continue

        if has_metadata and line == "@end":
            break
        
        if has_metadata and line.startswith("tags") and len(line) > 5:
            tags = line.replace("tags:", "").strip().split(" ")
            for tag in tags:
                if tag not in all_tags:
                    all_tags[tag] = []
                all_tags[tag].append(file)



# create tag_syms object in the same format as tags so it can be compared
all_syms = {}
for sym in get_notes(TAG_DIR):
    realpath = os.path.realpath(sym)
    tag = os.path.relpath(sym, TAG_DIR).split("/")[0]
    if tag not in all_syms:
        all_syms[tag] = []
    all_syms[tag].append(realpath)


# print(all_tags)
# print(all_syms)
if all_tags == all_syms:
    remove_empty_folders()
    print("syms and tags are the same - doing nothing")
    exit()


# find recently tagged files that havent been put into syms folder yet


def find_difference(a, b):
    # returns everything in a that isnt in b
    diffs = {}
    for tag in a.keys():
        if tag in a and tag in b:
            diff = list(set(a[tag]).difference(set(b[tag])))
            if diff:
                diffs[tag] = diff
        else:
            diffs[tag] = a[tag]
    return diffs


not_in_syms = find_difference(all_tags, all_syms)
remove_from_syms = find_difference(all_syms, all_tags)
#
# print(not_in_syms)
# print(remove_from_syms)


# remove syms
for tag in remove_from_syms.keys():
    tagList = remove_from_syms[tag]
    for realpath in tagList:
        target = TAG_DIR + "/" + tag + "/" + os.path.basename(realpath)
        os.unlink(target)

# create syms
for tag in not_in_syms.keys():
    tagList = not_in_syms[tag]
    for realpath in tagList:
        root = TAG_DIR + "/" + tag
        mkdir(root)
        destination = root + "/" + os.path.basename(realpath)
        os.symlink(realpath, destination)
        # print(destination)

remove_empty_folders()

# for tag in all_tags.keys():
#     tagList = all_tags[tag]
#
#     if tag in all_syms:
#         # check if lists are the same
#         if tagList == all_syms[tag]:
#             pass
#         else:
#             # add only the differences
#             not_in_syms[tag] = list(set(tagList).difference(set(all_syms[tag])))
#
#     else:
#         not_in_syms[tag] = tagList

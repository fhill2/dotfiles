from os.path import dirname, basename, splitext
import os
import re
def normalise_filepath(path):
    """used in notes_housekeeping to normalise all notes filenames/paths"""
    """used to normalize filenames in ~/data/vids"""
    """used in a stdin wrapper for map.xplr"""
    """this only accepts absolute filepaths"""
    """works on directories and files"""
    if not os.path.exists(path):
        return
    path = os.path.normpath(path) # strip trailing / from directory names so they are processed correctly
    parent = dirname(path)
    is_dir = os.path.isdir(path)
    

    base_name = os.path.split(path)[1] if is_dir else splitext(os.path.basename(path))[0]
    base_name = re.sub(r"[^a-zA-Z0-9\- ]", " ", base_name) # limit characters
    base_name = " ".join(base_name.split()) # normalise whitespace
    base_name = base_name.replace(" ", "-").lower()
    base_name = re.sub(r"[-]{2,}", "-", base_name)

    if is_dir:
        modified_abs = parent + os.sep + base_name
    else:
        ext = splitext(basename(path))[1]
        print(ext)
        modified_abs = parent + os.sep + base_name + ext
    return abs != modified_abs and modified_abs or abs


# create a python function normalises all file and folder names, limits the character set of the filename to only the alphabet and digits

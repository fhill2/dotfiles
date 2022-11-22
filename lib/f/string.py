from os.path import dirname, basename, splitext
import os
import re
def normalise_filename(abs):
    """used in notes_housekeeping to normalise all notes filenames/paths"""
    """used to normalize filenames in ~/data/vids"""
    """used in a stdin wrapper for map.xplr"""
    """this only accepts absolute filepaths"""
    """works on directories and files"""
    abs = os.path.normpath(abs) # strip trailing / from directory names so they are processed correctly
    parent = dirname(abs)
    filename = splitext(basename(abs))[0]
    ext = splitext(basename(abs))[1]
    filename = re.sub(r"[^a-zA-Z0-9\- ]", " ", filename) # limit characters
    filename = " ".join(filename.split()) # normalise whitespace
    filename = filename.replace(" ", "-").lower()
    filename = re.sub(r"[-]{2,}", "-", filename)
    modified_abs = parent + os.sep + filename + ext
    return abs != modified_abs and modified_abs or abs

#!/usr/bin/env python
import sys, os
from f.string import normalise_filepath

SHOULD_RENAME= True if len(sys.argv) > 1 and "rename" in sys.argv[1] else False

def stdin_normalise(lines):
    if SHOULD_RENAME:
        user_input = input(f'WARNING: you are about to rename {len(lines)} files. proceed Y/n? ')
        if not "Y" or not "y" in user_input:
            exit()

    for abs in lines:
        # TODO: support relative filepaths
        if not os.path.isabs(abs):
            print("not an absolute filepath - exiting")
            exit()

        normalised_filepath = normalise_filepath(abs)
        if SHOULD_RENAME:
            print(f"RENAMED: {abs} --> {normalised_filepath}")
            os.rename(abs, normalised_filepath)
        else:
            print(normalised_filepath)


# https://stackoverflow.com/questions/19172563/how-do-i-accept-piped-input-and-then-user-prompted-input-in-a-python-script
print("waiting for stdin input.. fd . -a | f_normalise_filename.py")
lines = sys.stdin.readlines()
lines = [path.strip() for path in lines]
sys.stdin = open("/dev/tty", "r")

# Use os.scandir() to get a list of file and folder names
# names = [entry.name for entry in os.scandir(path) if entry.is_file() or entry.is_dir()]

# Define a custom sorting function that places files at the beginning
def sort_names(path):
    if os.path.isfile(path):
        return (0, path)
    else:
        return (1, path)

# Sort the names so that files appear at the beginning
sorted_names = sorted(lines, key=sort_names)
stdin_normalise(sorted_names)

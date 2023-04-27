#!/usr/bin/python
print("this script deletes all neorg document metadata - you will lose data - remove exit() statement to run")

exit()
import os
from notes_norg_frontmatter import delete_multiple_lines, ROOT


# get all norg files
notes_files = []
for root, dirnames, filenames in os.walk(root):
    for filename in filenames:
        if filename.endswith(".norg"):
            notes_files.append(os.path.join(root, filename))

# filter all norg files to those only containg @document.meta at the start
neorg_metadata_files = []
for file in notes_files:
    with open(file, "r") as f:
        line = f.readline().rstrip()
        if line == "@document.meta":
            neorg_metadata_files.append(file)
        f.close()




# gather line range that needs deleting
for file in neorg_metadata_files:
    f = open(file, "r")
    Lines = f.readlines()

    line_numbers = []
    count = 0
    for line in Lines:
        line_numbers.append(count)
        count += 1
        if line.strip() == "@end":
            f.close()
            delete_multiple_lines(file, line_numbers)
            break


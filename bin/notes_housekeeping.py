#!/usr/bin/python
# from notes_frontmatter import ROOT, get_all_notes, frontmatter
# from frontmatter.default_handlers import YAMLHandler
# post = frontmatter.loads(fp)
from notes_frontmatter import get_all_notes, convert_norg_to_yaml_frontmatter, add_frontmatter, ensure_subdir_tags, tags_exist, get_frontmatter, get_tags_from_frontmatter
# fp = "/home/f1/tmp/norg.md"
# add_frontmatter(fp)

from f.string import normalise_filenames


# add frontmatter to files that dont have any frontmatter
# for note in get_all_notes():
    # add_frontmatter(note)

# fp = "/home/f1/dev/notes/1/arch-config/backup-sync/snapper-snapshots-backup.md"
# fp = "/home/f1/dev/notes/bookmark-workflow.md"

# for note in get_all_notes():
    # ensure_subdir_tags(note)

# for note in get_all_notes():
#     if tags_exist(note):
#         print(note)

# 1 get rid of all special characters

# from pathlib import Path






# for note in get_all_notes():
    # normalise_filename(note)




# https://github.com/python/cpython/blob/main/Tools/scripts/crlf.py
# ensure no windows line endings, only unix
import os
def lfcr_to_lf(filename):
    if os.path.isdir(filename):
        print(filename, "Directory!")
        return
    with open(filename, "rb") as f:
        data = f.read()
    if b'\0' in data:
        print(filename, "Binary!")
        return
    newdata = data.replace(b"\r\n", b"\n")
    if newdata != data:
        print(filename + " -> found lfcr line ending - processing")
        with open(filename, "wb") as f:
            f.write(newdata)
# for note in get_all_notes():
#     lfcr_to_lf(note)



# NOT USING IN WORKFLOW
# convert norg front matter to yaml
# for note in get_all_notes():
   # convert_norg_to_yaml_frontmatter(note)

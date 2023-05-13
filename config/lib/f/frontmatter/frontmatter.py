#!/usr/bin/python
NOTES_ROOT = "/home/f1/dev/notes"
import os
def get_all_notes():
    notes = []
    for root, dirnames, filenames in os.walk(NOTES_ROOT):
        for filename in filenames:
            if filename.endswith(".norg") or filename.endswith(".md"):
                notes.append(os.path.join(root, filename))
    return notes



# ========== PYTHON-FRONTMATTER WRAPPER CLASS - adds norg as a handler
from frontmatter.default_handlers import YAMLHandler, BaseHandler
# from frontmatter import Post
import frontmatter
import re


# BaseHandler.detect() is called from frontmatter.load() or frontmatter.loads()
class NORGHandler(BaseHandler):
    START_DELIMITER = "@document.meta"
    END_DELIMITER = "@end"
    FM_BOUNDARY = re.compile(r"^@document.meta\s*$|^@end\s*$", re.MULTILINE)

    def load(self, fm, **kwargs):
        """Parse Norg frontmatter"""
        metadata = {}
        for line in fm.split("\n"):
            if line == "":
                continue
            split = line.split(':')
            k = split[0].strip()
            v = split[1].strip()
            v = split[1].split(" ") if " " in v else v
            v = ' '.join(v).split() if isinstance(v, list) else v
            metadata[k] = v
        return metadata

    def export(self, metadata, **kwargs): 
        print("norg export not implemented yet")

frontmatter.handlers.append(NORGHandler())

def get_frontmatter(fp):
    with open(fp, "r") as f:
        text = f.read()
        post = frontmatter.loads(text)
        f.close()
    return post, text


def add_frontmatter(fp):
    """if frontmatter exists already - it wont write"""
    post, text = get_frontmatter(fp)
    # if a handler wasnt matched - then no frontmatter exists
    if not post.handler:
        post = frontmatter.loads(text, YAMLHandler(), tags="")
        with open(fp, "w") as f:
            f.write(frontmatter.dumps(post))

def tags_exist(fp):
    """returns true if note contains tags (are not empty)"""
    # TODO: add tags_fs
    post, text = get_frontmatter(fp)
    if "tags" in post:
        if post["tags"] == "" or len(post["tags"]) == 0:
            return False
        else:
            return True
    else:
        return False

def get_tags_from_frontmatter(post):
    """retrieves all tags from the frontmatter post object"""
    """as tags are in tags and tags_fs keys in frontmatter"""
    tags = []

    def append(key):
        if isinstance(post[key], list):
            for tag in post[key]:
                tags.append(tag)
        elif post[key] != "": 
            tags.append(post[key])
        
    if "tags" in post.keys():
        append("tags")
    if "tags_fs" in post.keys():
        append("tags_fs")

    # return tags list unduplicated
    return list(dict.fromkeys(tags))

def write_file(fp, body):
    """oneshot to overwrite the content portion of a file - leaving existing frontmatter untouched"""
    post = get_frontmatter(fp)[0]
    post.content = body
    with open(fp, "w") as f:
        f.write(frontmatter.dumps(post))

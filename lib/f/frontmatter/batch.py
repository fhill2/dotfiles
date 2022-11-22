from f.frontmatter.frontmatter import NOTES_ROOT, get_frontmatter
import os

def batch_convert_norg_to_yaml_frontmatter(fp):
    """if the frontmatter detected is not in neorg format - it wont write"""
    post, text = get_frontmatter(fp)

    if "NORGHandler" in str(post.handler):
        # only continue if the frontmatter detected is NORG
        with open(fp, "w") as f:
            post.handler = YAMLHandler()
            f.write(frontmatter.dumps(post))
            print(fp + " -> converted NORG to YAML frontmatter")
    elif "YAMLHandler" in str(post.handler):
        print(fp + " -> already contains YAML frontmatter")
    else:
        print(fp + " -> did not write as frontmatter is " + str(post.handler))




# folders 1,2,3,sort etc
approved_subdirs = [filename for filename in os.listdir(NOTES_ROOT) if os.path.isdir(os.path.join(NOTES_ROOT,filename))]
def batch_ensure_subdir_tags(fp):
    """ensure a tag exists for each subdir the note is in"""
    """e.g root/subdir1/subdir2 -> tags: subdir1, subdir2"""

    # if notes is not in notes root folder, do not process
    if NOTES_ROOT not in fp:
        print("file does not exist within notes folder - not processing")
        return

    subdirs = os.path.dirname(os.path.relpath(fp, NOTES_ROOT)).split(os.sep)
    if subdirs[0] not in approved_subdirs:
        print("note has to be within subfolder of notes_dir - 1,2,3,sort etc - not processing")
        return
    
    # remove the top level subdir folder
    del subdirs[0]

    post, text = get_frontmatter(fp)
    if "tags_fs" not in post:
        post["tags_fs"] = []

    post["tags_fs"] = post["tags_fs"] if isinstance(post["tags_fs"], list) else [ post["tags_fs"] ]
    unmodified_post_tags = post["tags_fs"].copy()

    for subdir in subdirs:
        if subdir not in post["tags_fs"]:
            post["tags_fs"].append(subdir)

    if post["tags_fs"] != unmodified_post_tags:
        with open(fp, "w") as f:
            print(fp + " -> found tags to add .. writing " + str(post["tags_fs"]))
            f.write(frontmatter.dumps(post))


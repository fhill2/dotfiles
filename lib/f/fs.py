import os

# as starfarm_find_git_repos.sh does not support git repos that start with . - repo_owner/.files etc
# https://gist.github.com/maifeeulasad/81539e1fd9eec7d41bb7c3cd0504d5c6
def git_dirs(startdir):
    """returns the git root of every git repo underneath startdir"""
    for dirpath, dirnames, _ in os.walk(startdir):
        if set(['info', 'objects', 'refs']).issubset(set(dirnames)):
            yield os.path.dirname(dirpath)

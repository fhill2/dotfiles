import os
import sys
import shutil

# as starfarm_find_git_repos.sh does not support git repos that start with . - repo_owner/.files etc
# https://gist.github.com/maifeeulasad/81539e1fd9eec7d41bb7c3cd0504d5c6
def git_dirs(startdir):
    """returns the git root of every git repo underneath startdir"""
    for dirpath, dirnames, _ in os.walk(startdir):
        if set(['info', 'objects', 'refs']).issubset(set(dirnames)):
            yield os.path.dirname(dirpath)







def flatten():
    directory = os.getcwd()

    if ( directory in ['/home/f1'] ):
            print("Error: Will not run in "+directory)
            exit()

    user_input = input(f'WARNING. You are about to flatten the current directory. This will delete all folders. proceed Y/n? ')
    if not "Y" or not "y" in user_input:
        exit()

    for dirpath, _, filenames in os.walk(directory, topdown=False):
        for filename in filenames:
            i = 0
            source = os.path.join(dirpath, filename)
            target = os.path.join(directory, filename)

            while os.path.exists(target):
                i += 1
                file_parts = os.path.splitext(os.path.basename(filename))

                target = os.path.join(
                    directory,
                    file_parts[0] + "_" + str(i) + file_parts[1],
                )

            shutil.move(source, target)

            print("Moved ", source, " to ", target)

        if dirpath != directory:
            os.rmdir(dirpath)

            print("Deleted ", dirpath)


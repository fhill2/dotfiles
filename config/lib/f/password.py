import subprocess
from shutil import which
def get_pass(query):
    if which("pass") is not None:
        return subprocess.run(['pass', 'show', query], capture_output=True).stdout.decode('utf-8').strip()
    else:
        print("which(pass) == false - pass not installed")
        exit()

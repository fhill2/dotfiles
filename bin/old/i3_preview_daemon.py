#!/usr/bin/env python

# this previewer is inspired by preview_tabbed from nnn plugins
# I recreated this as I wanted a sway i3 agnostic previewer (that did not rely on tabbed)
# it is recreated in python using ipc python library specifically as I can wait for windows to be ready subscribing to i3 events
# it is meant to keep 1 terminal constantly open to show any terminal previews, 
# and to keep only 1 GUI previewer open at a time

# https://pypi.org/project/python-magic/
# python-magic use libmagic library
# pistol uses libmagic C library
import magic, json, subprocess, multiprocessing, os, shlex, time, psutil
# from f.util import run_sh, dump
from f.hash import hash_file

HOME = os.getenv("HOME")
CACHEDIR = os.path.join(HOME, ".cache", "i3_preview")
os.makedirs(CACHEDIR, exist_ok=True)

from i3ipc import Connection, Event


# deps:
# viu - image viewer
# zathura - pdf
# mpv - video audio


# sudo pip install unoserver - converting .docx to pdf to preview with zathura (otherwise I have to open libreoffice in the preview :())
# needs to be installed as sudo, as it needs to be in the same python env as libreoffice install

# mimes:
# .docx ->  application/vnd.openxmlformats-officedocument.wordprocessingml.document
# .bin -> application/octet-stream
# .md -> text/plain
# 



# ========== PREVIEWER CLASS START ==========

class Previewer():
    def __init__(self):
        self.i3 = Connection()
        self.pwins = False
        self.term_exists = False

    def update_state(self):
        try:
            self.pwins = self.i3.get_tree().find_marked("preview_container")[0].nodes
        except:
            pass
        else:
            all_window_classes = [win.window_class for win in self.pwins]
            self.term_exists = True if "kitty" in all_window_classes else False

        if not self.pwins:
            self.mwin = self.i3.get_tree().find_focused()
            self.mwin.command("splith")


    def find_hidden_preview_windows(self):
        """find the visible windows underneath container passed in"""
        """TODO: this will not work on sway - however sway includes visible property in the json returned from get_tree, and can be easily edited to do so"""
        visible_windows = []
        for w in self.pwins:
            try:
                xprop = subprocess.check_output(['xprop', '-id', str(w.window)]).decode()
            except FileNotFoundError:
                raise SystemExit("The `xprop` utility is not found!" " Please install it and retry.")

            if '_NET_WM_STATE_HIDDEN' in xprop:
                visible_windows.append(w)

        return visible_windows

    def open_wait_window(self, cmd):
        """opens a previewer window in the preview container"""
        def on_window_new(_, e):
            self.i3.main_quit()
            global WINDOW_DATA
            WINDOW_DATA = e
        self.i3.on(Event.WINDOW_NEW, on_window_new)
        def open_window():
            subprocess.run(shlex.split(cmd))
            # i3.command(f"exec {cmd}")
        proc = multiprocessing.Process(target=open_window)
        if self.pwins:
            self.pwins[0].command("focus")
        proc.start()
        self.i3.main()
        con = WINDOW_DATA.container
        if not self.pwins:
            con.command("splith; layout tabbed; focus parent; mark preview_container")
        return con


    def preview(self, cmd):
        """opens a non terminal previwer window and kills all other non terminal previewer windows"""
        self.update_state()

        con = self.open_wait_window(cmd)

        # kill all windows that arent terminal windows (excluding the window just launched)
        if self.pwins:
            for win in self.pwins:
                if win.window_class != "kitty":
                    if win != con: 
                        win.command("kill")

        self.mwin.command("focus")




    def preview_terminal(self, abs):
        """previews in the terminal window"""
        self.update_state()
        if not self.term_exists:
            con = self.open_wait_window(f"kitty sh -c 'i3_preview_terminal.sh \"{abs}\"'")
            # TODO: if the writer sends to pipe before reader opens, i3_preview_terminal.sh receives spammed input
            # sleep fixes this
            time.sleep(0.1)
            self.term_fifo_write = open('/home/f1/tmp/preview_terminal.fifo', 'w')
        self.term_fifo_write.write(f"{abs}\n")
        self.term_fifo_write.flush()
            
        # as no window is opened (if self.term_exists is True | on second invocation)
        # terminal window has to be refocused to be the visible tab in the tabbed preview container
        # checks for the prescense of "con" first, as if con exists, a window was spawned, and i3 implicitly focused new windows byt default
        if "con" not in locals():
            # hidden_window_classes = [win.window_class for win in find_hidden_preview_windows()]
            for win in self.find_hidden_preview_windows():
                if win.window_class == "kitty":
                    win.command("focus")


        self.mwin.command("focus")


    def close_child_procs(self):
        # https://gist.github.com/jizhilong/6687481?permalink_comment_id=3057122#gistcomment-3057122
        for child in psutil.Process(os.getpid()).children(recursive=True):
            child.kill()



# ========== PREVIEWER CLASS END ==========

def doc_to_pdf(abs):
    """convert doc to pdf using unoserver"""
    """if the document exists - it reads from cache"""
    ensure_unoserver()
    # abs = "/home/f1/Downloads/lawyer/nosubmit/Entry Clearance Partner Questionnaire Main Applicant.docx"
    hash_abs = hash_file(abs)
    print("has abs: ", hash_abs)
    destination = os.path.join(CACHEDIR, f"{hash_abs}.pdf")
    if not os.path.exists(destination):
        print(f'python3 -m unoserver.converter "{abs}" "{destination}"')
        subprocess.run(shlex.split(f'/usr/bin/python3 -m unoserver.converter "{abs}" "{destination}"'))
        print("CONVERTING DOC TO PDF")

    return destination, "application/pdf"


def ensure_unoserver():
    """for .docx - it is converted to a pdf using unoserver+libreoffice"""
    """this ensures server is running"""
    def run_unoserver():
        # subprocess.run(shlex.split(cmd))
        import unoserver.server
    # if lsof does not return anything on port 2002 - unoserver is not running yet
    # as default unoserver port is 2002
    # if lsof returns 0 - unoserver is already running
    if subprocess.run("lsof -i :2002", shell=True).returncode != 0:
        proc = multiprocessing.Process(target=run_unoserver)
        proc.start()
        print("unoserver not running - starting")



P = Previewer()

def handle_mime(abs):
    abs = os.path.realpath(abs)
    if not os.path.isabs(abs):
        subprocess.run("notify-send 'pass in an absolute path'")
        return

    if os.path.isdir(abs):
        mime = "inode/directory"
    else:
        mime = magic.from_file(abs, mime=True)
    print(mime)
    print(abs)
    if "application/vnd.openxmlformats" in mime:
        abs, mime = doc_to_pdf(abs)

    mimes = [
        (["video/", "audio/", "image/"], f'mpv --keep-open always "{abs}"'),
    (["office", "document", "application/pdf", "application/vnd.openxmlformats-officedocument.wordprocessingml.document"], f'zathura "{abs}"'),
        (["text/", "inode/directory", "application/octet-stream", "font/"], False) # terminal
    ]
    for m in mimes:
        queries = m[0]
        cmd = m[1]
        for query in queries:
            if query in mime:
                if cmd:
                    P.preview(cmd)
                else:
                    P.preview_terminal(abs)
                return
    print("NO MATCH FOUND ============")
    # if no match found
    P.preview_terminal(abs)



# because I cant find out how to enable / disable spaceFM events
# sending start | open to the pipe achieves the same result as enabling | disabling this
ENABLED = False

def handle_action(msg):
    if msg == "close" or msg == "stop":
        subprocess.run("notify-send 'stopping previewer'", shell=True)
        P.close_child_procs()
    elif msg == "open" or msg == "start":
        subprocess.run("notify-send 'starting previewer'", shell=True)
        global ENABLED
        ENABLED = True

FIFO="/home/f1/tmp/preview.fifo"
while True:
    with open(FIFO, 'r') as pipe:
        msg = pipe.read().strip()
        if "/" in msg:
            # preview
            if ENABLED:
                handle_mime(msg)
        else:
            handle_action(msg)



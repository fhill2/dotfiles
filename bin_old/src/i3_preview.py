#!/usr/bin/env python3
import subprocess, multiprocessing, shlex, time, magic, os
import dbus
from f.util import dump_out, dump, log
from i3ipc import Connection, Event


# deps:
# mpv
# mpv-mpris -> dbus connection to mpv
# pip install dbus-python

# TODO:
# convert each previewer to a class and have setup() preview() for every class

# TODO:
# mpv still glitches because the window is moved from workspace 7 to current, then resized by opening the media, then moved to the center
# this could be made better by when the previewer starts, alll previewers are moved to the scratchpad. then scratchpad show can be used to hide show them
# regardless of the position of the previewer window on workspace 7, when its moved to the current workspace, the position is reset


# TODO:
# make sure active window is focused
# look at i3 daemons - maybe split code into i3 setup, this can run as a hook when starting i3
# and the previewer code
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

# ========== PREVIEWER CLASS START ==========
class Previewer():
    def __init__(self):
        self.bus = dbus.SessionBus()
        self.i3 = Connection()
        self.current_previewer = False
        self.previewers = ["kitty", "mpv", "zathura"]
        self.previewer_marks = []
        for mark in self.previewers:
            self.previewer_marks.append(f"preview_{mark}")

        self.setup_mpv()
        self.setup_zathura()
        self.setup_kitty()
        
        self.update_status()


    # def open_wait_window(self, cmd):
    #         """opens a previewer window in the preview container"""
    #         def on_window_new(_, e):
    #             self.i3.main_quit()
    #             global WINDOW_DATA
    #             WINDOW_DATA = e
    #         self.i3.on(Event.WINDOW_NEW, on_window_new)
    #         def open_window():
    #             subprocess.run(shlex.split(cmd))
    #         multiprocessing.Process(target=open_window).start()
    #         self.i3.main()
    #         return WINDOW_DATA.container

    def setup_mpv(self):
        """setup mpv - runs once on script startup"""

        # TODO: shut all mpv windows before connecting - d-foot shows:
        # 1st instance -> org.mpris.MediaPlayer2.mpv
        # 2nd instance -> org.mpris.MediaPlayer2.mpv.instance<PID>
        # or handle connecting to the correct interface by scanning object names to see if they contain the PID
        remote_obj = self.bus.get_object('org.mpris.MediaPlayer2.mpv', '/org/mpris/MediaPlayer2')
        self.mpv_dbus = dbus.Interface(remote_obj, "org.mpris.MediaPlayer2.Player")
        # return con
        
    def setup_zathura(self):
        """setup zathura - runs once on script startup"""
        # TODO: unreliable - better to get pid by using dbus-python. can maybe use dbus introspection
        # output = subprocess.check_output(f'xprop -id {con.window} _NET_WM_PID', shell=True).decode("utf-8")
        # pid = output.split(" ")[2].strip()
        pid = subprocess.check_output(f'pidof zathura', shell=True).decode("utf-8").strip()
        # con.pid = None for zathura window
        # therefore, retrieve the PID via xprop. window ID --> PID

        # sleep because zathura window opens before dbus interface becomes ready
        time.sleep(0.3)
        remote_obj = self.bus.get_object(f'org.pwmt.zathura.PID-{pid}', '/org/pwmt/zathura')
        self.zathura_dbus = dbus.Interface(remote_obj, "org.pwmt.zathura")
        # return con

    def setup_kitty(self):
        """setup kitty - runs once on script startup"""
        # TODO: if the writer sends to pipe before reader opens, i3_preview_terminal.sh receives spammed input, sleep necessary
        time.sleep(0.1)
        self.term_fifo_write = open('/home/f1/tmp/preview_terminal.fifo', 'w')
        log("i3_preview: setup preview_terminal.fifo pipe")
        # return con


    # def update_find_or_setup(self, tree, mark):
    #     """finds the marked window in i3"""
    #     """if it does not exist, runs setup"""
    #     setup = getattr(self, f"setup_{mark}")
    #     con = tree.find_marked(f"preview_{mark}")
    #     setattr(self, mark, con[0]) if con else setup()

    def update_status(self):
        """checks that all previewer windows are in the correct status before previewing"""
        """might have to block here and wait for i3 completed startup event when running as a systemd service"""

        tree = self.i3.get_tree()
        self.focused_ws = tree.find_focused().workspace()

        for previewer in self.previewers:
            # self.update_find_or_setup(tree, previewer)
            try:
                setattr(self, previewer, tree.find_marked(f"preview_{previewer}")[0])
            except:
                print("ERROR: update_status() CANNOT find previewer window: " + previewer)
        self.get_current_previewer()

    def get_current_previewer(self):
        """returns the current previewer container if there is a previewer currently shown on the current workspace"""
        def iter_children(c):
            if c.marks:
                for mark in c.marks:
                    if mark in self.previewer_marks:
                        self.current_previewer = c
                        return
            for cc in c.nodes:
                iter_children(cc)

            for cc in c.floating_nodes:
                iter_children(cc)

        return iter_children(self.focused_ws)
 

    def preview_cmd(self, abs, chosen_previewer, chosen_previewer_str):
        self.mpv_dbus.Pause()
        if chosen_previewer_str == "mpv":
            self.mpv_dbus.OpenUri(abs)
            self.mpv_dbus.Play() 
            # sleep needed here before window is moved to the center - probably because mpv hasnt finished resizing the window yet
            # time.sleep(0.05)
            
        if chosen_previewer_str == "zathura":
            self.zathura_dbus.ExecuteCommand(f'open "{abs}"') # because ExecuteComman focuses zathura

        if chosen_previewer_str == "kitty":
            self.term_fifo_write.write(f"{abs}\n")
            self.term_fifo_write.flush()
            # because open() blocks when running under systemd and im not sure why
            # subprocess.run(shlex.split(f'echo "{abs}" > ~/tmp/preview_terminal.fifo'), shell=True)



    def preview(self, abs, chosen_previewer_str):
        self.update_status()
        chosen_previewer = getattr(self, chosen_previewer_str)

        chosen_previewer_ws = chosen_previewer.workspace().ipc_data["name"]
        focused_ws = self.focused_ws.ipc_data["name"]
    
        if self.current_previewer != chosen_previewer:
            if self.current_previewer and self.current_previewer != chosen_previewer:
                print("moving current previewer back to previewer workspace")
                self.current_previewer.command("move to workspace number 7")

            if chosen_previewer_ws != focused_ws:
                print("moving chosen previewer to focused workspace")
                chosen_previewer.command(f"move to workspace number {focused_ws}; move to position 0 0")
                # time.sleep(1)
                # chosen_previewer.command("move to position center")
                # chosen_previewer.command(f'floating enable; border none')

        chosen_previewer.command("move to position 0 0")
        self.preview_cmd(abs, chosen_previewer, chosen_previewer_str)

    def stop_previewer(self):
        self.update_status()
        self.current_previewer.command("move to workspace number 7")
        # self.i3.command(f'[con_mark={self.current_previewer}] move to workspace number 7')



# ========== PREVIEWER CLASS END ==========

# TODO:
# move all windows back to workspace 7 after turning off

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
        (["video/", "audio/", "image/"], 'mpv'),
    (["office", "document", "application/pdf", "application/vnd.openxmlformats-officedocument.wordprocessingml.document"], 'zathura'),
        (["text/", "inode/directory", "application/octet-stream", "font/"], 'kitty')
    ]
    for m in mimes:
        queries = m[0]
        previewer = m[1]
        for query in queries:
            if query in mime:
                P.preview(abs, previewer)
                return

    # print("NO MATCH FOUND ============")
    P.preview(abs, "kitty")

# because I cant find out how to enable / disable spaceFM events
# sending start | open to the pipe achieves the same result as enabling | disabling this
ENABLED = False


def start_previewer():
    subprocess.run("notify-send 'starting previewer'", shell=True)
    global ENABLED
    ENABLED = True

def stop_previewer():
    subprocess.run("notify-send 'stopping previewer'", shell=True)
    P.stop_previewer()
    global ENABLED
    ENABLED = False

def handle_action(msg):
    global ENABLED
    if msg == "close" or msg == "stop":
        stop_previewer()
    elif msg == "open" or msg == "start":
        start_previewer()
    elif msg == "toggle":
        stop_previewer() if ENABLED else start_previewer()


FIFO="/home/f1/tmp/preview.fifo"

if os.path.exists(FIFO):
    os.remove(FIFO)
os.mkfifo(FIFO)

# before initialising (which creates windows)
# make sure the workspace on the primary monitor is focused, so the new previewer workspace is created on the primary monitor

log("i3_preview: previewer starting up..")

# TODO: if i3_preview_startup.py is launched immediately before this, dbus-python in this script tries to connect to mpv dbus that is not available yet
# FIX: make dbus-python wait for the dbus service to come available, instead of crashing
time.sleep(1)


P = Previewer()
log("i3_preview: previewer ready")
while True:
    with open(FIFO, 'r') as pipe:
        msg = pipe.read().strip()
        if "/" in msg:
            if ENABLED:
                handle_mime(msg)
        else:
            handle_action(msg)




# OLD
# def startup():
#     pass
#
#     subprocess.run("pkill mpv; sleep 0.1", shell=True)
#     # you can change x11 class name of mpv window - could you assign and class name change instead of marks
#     # https://mpv.io/manual/master/#window
#
#     # --keep-open=always -> otherwise when previewing images, mpv closes automatically
#     # --force-window=immediate -> force mpv to spawn a window and not stay in CLI mode
#     # - -> read from stdin - paired with --force-window to force the window to open
#     # --geometry -> experimenting with mpv to lock aspect ratio when resizing
#     mpv_cmd = "mpv --autofit-larger=50%x50% --keep-open=always --force-window=immediate -"
#     con = self.open_wait_window(mpv_cmd)
#     con.command(f"mark preview_mpv; floating enable; move container to workspace number 7")
#     con.command(f'resize set width {50} ppt height {50} ppt')
#     con.command('move to position 0 0')
#
#     # setup zathura
#     con = self.open_wait_window("zathura")
#     con.command(f"mark preview_zathura; floating enable; move container to workspace number 7")
#     con.command(f'resize set width {30} ppt height {80} ppt')
#     # setup kitty
#     con = self.open_wait_window("kitty sh -c 'i3_preview_terminal.sh'")
#     con.command(f"mark preview_kitty; floating enable; move container to workspace number 7")
#     con.command(f'resize set width {30} ppt height {80} ppt')

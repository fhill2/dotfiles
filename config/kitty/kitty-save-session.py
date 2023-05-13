#!/.nix-profile/bin/python


#https://github.com/dflock/kitty-save-session/blob/main/kitty-convert-dump.py
import json
import sys

def env_to_str(env):
  """Convert an env list to a series of '--env key=value' parameters and return as a string."""
  # FIXME: running launch with --env params doesn't seem to work - I get this error:
  # Failed to launch child: --env
  # With error: No such file or directory
  # Press Enter to exit.
  # So, skip this for now.
  return ''
  # s = ''
  # for key in env:
  #   s += f"--env {key}={env[key]} "
  
  # return s.strip()

def cmdline_to_str(cmdline):
  """Convert a cmdline list to a space separated string."""
  s = ''
  for e in cmdline:
    s += f"{e} "

  return s.strip()

def fg_proc_to_str(fg):
  """Convert a foreground_processes list to a space separated string."""
  s = ''
  fg = fg[0]

  # s += f"--cwd {fg['cwd']} {cmdline_to_str(fg['cmdline'])}"
  s += f"{cmdline_to_str(fg['cmdline'])}"

  return s

def convert(session):
  """Convert a kitty session dict, into a kitty session file and output it."""
  for os_window in session:
    print('\nnew_os_window\n')

    for tab in os_window['tabs']:
      print(f"new_tab {tab['title']}")
      # print('enabled_layouts *)
      print(f"layout {tab['layout']}")
      # This is a bit of a kludge to set cwd for the tab, as
      # setting it in the launch command didn't work, for some reason?
      if tab['windows']:
        print(f"cd {tab['windows'][0]['cwd']}")

      for w in tab['windows']:
        print(f"title {w['title']}")
        print(f"launch {env_to_str(w['env'])} {fg_proc_to_str(w['foreground_processes'])}")
        if w['is_focused']:
          print('focus')


if __name__ == "__main__":
  stdin = sys.stdin.readlines()
  session = json.loads(''.join(stdin))
  convert(session)

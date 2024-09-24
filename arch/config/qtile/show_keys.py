def show_keys(keys):
  """
  print current keybindings in a pretty way for a rofi/dmenu window.
  """
  key_help = ""
  keys_ignored = (
      "XF86AudioMute",  #
      "XF86AudioLowerVolume",  #
      "XF86AudioRaiseVolume",  #
      "XF86AudioPlay",  #
      "XF86AudioNext",  #
      "XF86AudioPrev",  #
      "XF86AudioStop",
  )
  text_replaced = {
      "mod4": "[S]",  #
      "control": "[Ctl]",  #
      "mod1": "[Alt]",  #
      "shift": "[Shf]",  #
      "twosuperior": "²",  #
      "less": "<",  #
      "ampersand": "&",  #
      "Escape": "Esc",  #
      "Return": "Enter",  #
  }
  for k in keys:
    if k.key in keys_ignored:
      continue

    mods = ""
    key = ""
    desc = k.desc.title()
    for m in k.modifiers:
      if m in text_replaced.keys():
        mods += text_replaced[m] + " + "
      else:
        mods += m.capitalize() + " + "

    if len(k.key) > 1:
      if k.key in text_replaced.keys():
        key = text_replaced[k.key]
      else:
        key = k.key.title()
    else:
      key = k.key

    key_line = "{:<30} {}".format(mods + key, desc + "\n")
    key_help += key_line

    # debug_print(key_line)  # debug only

  return key_help


source $HOME/.profile
#
#
# s="$(nvidia-settings -q CurrentMetaMode -t)"
# if [[ "${s}" != "" ]]; then
#   s="${s#*" :: "}"
#   nvidia-settings -a CurrentMetaMode="${s//\}/, ForceCompositionPipeline=On\}}"
# fi

# # so I can use i3-msg or swaymsg interchangably in bash scripts
if [[ -n "${DISPLAY}" ]]; then
  [[ "$(readlink /usr/bin/swaymsg)" != "/usr/bin/i3-msg" ]] && sudo ln -sf /usr/bin/i3-msg /usr/bin/swaymsg
fi
#
if [[ -n "${WAYLAND_DISPLAY}" ]]; then
  [[ "$(readlink /usr/bin/i3-msg)" != "/usr/bin/swaymsg" ]] && sudo ln -sf /usr/bin/swaymsg /usr/bin/i3-msg
fi

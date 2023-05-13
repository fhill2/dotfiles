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

unlock_bw_if_locked() {
  if [[ -z $BW_SESSION ]] ; then
    >&2 echo 'bw locked - unlocking into a new session'
    export BW_SESSION="$(bw unlock --raw)"
  fi
}

load_webflow_wombles_portal() {
  unlock_bw_if_locked
  webflow_token="$(bw get notes webflow_wombles_portal)"
  export WEBFLOW_TOKEN="${webflow_token}"
}

load_cloudinary() {
  unlock_bw_if_locked
  cloudinary_key="$(bw get notes cloudinary_wombles_key)"
  cloudinary_secret="$(bw get notes cloudinary_wombles_secret)"
  # https://cloudinary.com/documentation/django_integration#setting_the_cloudinary_url_environment_variable
  export CLOUDINARY_URL="cloudinary://${cloudinary_key}:${cloudinary_secret}@wombles"
}


# nvd() {
#   if [ -n "$1" ]; then
#     nvim --cmd 'lua load_profile="dropdown"' -c $1
#   else
#     nvim --cmd 'lua load_profile="dropdown"'
#   fi
# }
#
# f_telescope_repo() {
#   nvim --cmd 'lua load_profile="dropdown"' -c 'lua require"plugin.telescope.repo".show()'
#   result=$(head -1 /tmp/dropdown)
#   cd "$result"
# }
#
#
# f_omni_global() {
#   nvim --cmd 'lua load_profile="dropdown"' -c 'lua require"plugin.omni.gshow".gshow()'
#   #result=$(head -1 /tmp/dropdown)
#   source /tmp/dropdown
#   #echo "$result"
#   #cd "$result"
# }



ff_dirs_repos() {
  nvim --cmd 'lua CLI=true' -c 'lua require("plugin.telescope.wrap").ff_dirs_repos()'
  result=$(head -1 $HOME/tmp/cli)
  cd "$result"
}

ff_file_browser() {
  nvim --cmd 'lua CLI=true' -c 'Telescope file_browser'
  result=$(head -1 $HOME/tmp/cli)
  echo "$RESULT"
  cd "$result"
}


# GLOBALS SETTINGS
# CURSOR CUSTOMIZATION
ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BEAM
ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK
ZVM_OPPEND_MODE_CURSOR=$ZVM_CURSOR_UNDERLINE

ZVM_ESCAPE_KEYTIMEOUT=0.01
# ZVM_CURSOR_USER_DEFAULT
# ZVM_CURSOR_BLOCK
# ZVM_CURSOR_UNDERLINE
# ZVM_CURSOR_BEAM
# ZVM_CURSOR_BLINKING_BLOCK
# ZVM_CURSOR_BLINKING_UNDERLINE
# ZVM_CURSOR_BLINKING_BEAM


f_zvm_list_keybinds() {
f_list_keybinds.py | fzf
}


# function zvm_fzf_fd() {
# f_fzf 'fd'
# #echo "fzf_fd"
# }
# function zvm_fzf_fd_1() {
#   f_fzf 'fd_1'
# }

function f_reload(){
  source ~/.zshrc
  source ~/.zshenv
}


#https://unix.stackexchange.com/questions/122078/how-to-bind-a-key-sequence-to-a-widget-in-vi-cmd-mode-zsh
# vim like key sequences for zsh, unbind prefix key first
bindkey -a -r ' h'
bindkey -a -r ' f'
bindkey -a -r ' r'
#zle -N f_reload_zsh

# The plugin will auto execute this zvm_after_lazy_keybindings function
# this function is run when your first enter normal mode
# so if zsh starts in insert mode, the insert mappings in this function might not work
function zvm_after_lazy_keybindings() {

  zvm_define_widget f_zvm_list_keybinds
  zvm_define_widget f_reload
  # zvm_define_widget ff_dirs_repos
  # zvm_define_widget ff_files_browser

# EXAMPLES: 
# zvm_bindkey viins '^L' reload-zsh
# zvm_bindkey vicmd '^o' f_tw_zle

# zvm_bindkey vicmd ' rr' f_reload
  zvm_bindkey vicmd ' fr' ff_dirs_repos
  zvm_bindkey vicmd ' fb' ff_file_browser
}





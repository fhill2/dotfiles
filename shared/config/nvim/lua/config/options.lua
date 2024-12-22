-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--
vim.o.shell = "/bin/zsh"
vim.o.swapfile = false

-- https://neovim.io/doc/user/ft_sql.html#sql-completion-static
-- This conflicts with Exit Insert Mode when Editing an SQL File

vim.g.omni_sql_no_default_maps = 1
vim.g.ftplugin_sql_omni_key = ""

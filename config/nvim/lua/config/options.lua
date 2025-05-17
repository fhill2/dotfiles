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

-- neovim supports OSC 52 as a clipboard provider
-- copying text from neovim running in an SSH terminal is not configured by default
-- https://github.com/neovim/neovim/discussions/28010#discussioncomment-10719238
local function paste()
  return {
    vim.split(vim.fn.getreg(""), "\n"),
    vim.fn.getregtype(""),
  }
end

if vim.env.SSH_TTY then
  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = paste,
      ["*"] = paste,
    },
  }
end

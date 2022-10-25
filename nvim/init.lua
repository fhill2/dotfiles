-- vim.cmd"set packpath+=~/repos/packer-fork"
-- vim.cmd "set rtp+=~/repos/pack/packer/start/*"
-- vim.cmd "set rtp+=~/repos/pack/packer/start/*/after"

-- if changing repo install path, they must be under $packpath/pack/packer/opt
--vim.cmd "set packpath+=~/repos"

require("globals")
require("opts")
-- dump(package.loaded)
-- fp = vim.fn.stdpath("data") .. "/site/pack/packer/start/sg.nvim/lua/"
-- dump(dofile())

-- https://github.com/wbthomason/dotfiles/blob/linux/neovim/.config/nvim/lua/plugins.lua
--local packer = require("packer")
-- packer.init({
-- package_root = vim.loop.os_homedir() .. "/repos/pack",
--plugin_package = "packer",
-- snapshot_path = vim.loop.os_homedir() .. "/repos/snapshots",
--})
--packer.reset()
require("plugins")
require("plugins-shared")

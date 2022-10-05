-- local use = require "packer".use

-- these plugins are shared with dropdown and main config
local use = require("packer").use

-- attempt to find local repo, otherwise fallback to git
local local_or_git = function(path, fallback)
	if path:sub(1, 1) == "~" then
		path = vim.loop.os_homedir() .. path:sub(2, -1)
	end
	if vim.loop.fs_stat(path) then
		return path
	else
		return fallback
	end
end

use({ "kyazdani42/nvim-web-devicons" })

-- use({
--   'marko-cerovac/material.nvim',
--   config = function() require "plugin.material" end,
-- })

use({
	local_or_git("~/repos/packer-fork/telescope.nvim", "nvim-telescope/telescope.nvim"),
	config = function()
		require("plugin.telescope.init")
	end,
	requires = { "nvim-lua/plenary.nvim" },
})

use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
use({
	"nvim-treesitter/nvim-treesitter",
	commit = "c466ffd860dc7e01591324612082715707bdab75",
	config = function()
		require("plugin.treesitter")
	end,
})
use("nvim-telescope/telescope-fzy-native.nvim")

use(local_or_git("~/repos/packer-fork/telescope-file-browser.nvim", "nvim-telescope/telescope-file-browser.nvim"))

use({ "cljoly/telescope-repo.nvim" })
use("jvgrootveld/telescope-zoxide")
use({
	"nvim-telescope/telescope-frecency.nvim",
	requires = "kkharji/sqlite.lua",
})

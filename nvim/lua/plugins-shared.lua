-- local use = require "packer".use

-- these plugins are shared with dropdown and main config
local use = require "packer".use

use({ "kyazdani42/nvim-web-devicons" })

use({
  'marko-cerovac/material.nvim',
  config = function() require "plugin.material" end,
})

use({
  "nvim-telescope/telescope.nvim",
  config = function()
    require("plugin.telescope.init")
  end,
  requires = { "nvim-lua/plenary.nvim" }
})
use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
use({
  "nvim-treesitter/nvim-treesitter",
  config = function()
    require('plugin.treesitter')
  end,
})
use("nvim-telescope/telescope-fzy-native.nvim")
use("nvim-telescope/telescope-file-browser.nvim")
use({ "cljoly/telescope-repo.nvim" })
use("jvgrootveld/telescope-zoxide")
use({
  "nvim-telescope/telescope-frecency.nvim",
  requires = "tami5/sqlite.lua" })

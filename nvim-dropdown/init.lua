local uv = vim.loop

_G.f = {}
-- TODO add fs_stat to this
_G.f.home = vim.loop.os_homedir()
_G.f.cl = _G.f.home .. "/cl"

_G.f.dev = _G.f.home .. "/dev"
_G.f.dev_cl = _G.f.dev .. "/cl"
_G.f.old = _G.f.dev_cl .. "/old"
_G.f.dot = _G.f.dev .. "/dot"


vim.cmd("packadd packer.nvim")
package.path = package.path .. ";/home/f1/dev/dot/home-manager/config/nvim/lua/?.lua"
require("packer").startup(function(use)
use("https://github.com/xiyaowong/nvim-transparent")

  use({
    --forks .. "/telescope.nvim",
    "nvim-telescope/telescope.nvim",
    opt = false,
    config = function()
      require"plugin.telescope.init"
      --dofile("/home/f1/dev/dot/home-manager/config/nvim/lua/plugin/telescope/init.lua")
    end,
    requires = {
      "dhruvmanila/telescope-bookmarks.nvim",
      "nvim-lua/popup.nvim",
      "cljoly/telescope-repo.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-symbols.nvim",
      "nvim-telescope/telescope-fzy-native.nvim",
      --"jvgrootveld/telescope-zoxide",
      "nvim-telescope/telescope-frecency.nvim",
      "kyazdani42/nvim-web-devicons",
    },
  })

  use({
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    --cmd = { "TSInstall", "TSInstallInfo", "TSTSBufEnable", "TSBufDisable", "TSEnableAll", "TSDisableAll", "TSModuleInfo" },
    opt = true,
    event = "BufRead",
    requires = {
      { "nvim-treesitter/playground", cmd = "TSHighlightCapturesUnderCursor" },
    },
    config = function() require('plugin.treesitter') end,
--      dofile("/home/f1/dev/dot/home-manager/config/nvim/lua/plugin/treesitter.lua")
  })
  use({
     "folke/tokyonight.nvim",
     config = function()
       require("plugin.tokyonight")
     end,
   })
end)



-- if not uv.fs_stat("/tmp/dropdown") then
--   os.execute("mkfifo /tmp/dropdown")
-- end

vim.opt.termguicolors = true
require("transparent").setup({
  enable = true, -- boolean: enable transparent
  extra_groups = { -- table/string: additional groups that should be clear
    -- In particular, when you set it to 'all', that means all avaliable groups

    -- example of akinsho/nvim-bufferline.lua
    "BufferLineTabClose",
    "BufferlineBufferSelected",
    "BufferLineFill",
    "BufferLineBackground",
    "BufferLineSeparator",
    "BufferLineIndicatorSelected",
  },
  exclude = {}, -- table: groups you don't want to clear
})

vim.g.transparent_enabled = true 

vim.o.laststatus = 1

-- _G.pipe_send = function(msg)
-- os.execute(('echo "%s" > /tmp/dropdown'):format(msg))
-- end

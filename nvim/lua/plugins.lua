local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	packer_bootstrap =
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
end
vim.cmd([[packadd packer.nvim]])
local packer = require("packer")
-- all plugins put in /start by default
local use = packer.use
packer.init({})
use({ "wbthomason/packer.nvim", opt = true })
-- Oct 2022 - bootstrap packer config above

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

-- -- https://github.com/wbthomason/packer.nvim#specifying-plugins
-- legend
-- use {
--   'myusername/example',        -- The plugin location string
--   -- The following keys are all optional
--   disable = boolean,           -- Mark a plugin as inactive
--   as = string,                 -- Specifies an alias under which to install the plugin
--   installer = function,        -- Specifies custom installer. See "custom installers" below.
--   updater = function,          -- Specifies custom updater. See "custom installers" below.
--   after = string or list,      -- Specifies plugins to load before this plugin. See "sequencing" below
--   rtp = string,                -- Specifies a subdirectory of the plugin to add to runtimepath.
--   opt = boolean,               -- Manually marks a plugin as optional.
--   bufread = boolean,           -- Manually specifying if a plugin needs BufRead after being loaded
--   branch = string,             -- Specifies a git branch to use
--   tag = string,                -- Specifies a git tag to use. Supports '*' for "latest tag"
--   commit = string,             -- Specifies a git commit to use
--   lock = boolean,              -- Skip updating this plugin in updates/syncs. Still cleans.
--   run = string, function, or table, -- Post-update/install hook. See "update/install hooks".
--   requires = string or list,   -- Specifies plugin dependencies. See "dependencies".
--   rocks = string or list,      -- Specifies Luarocks dependencies for the plugin
--   config = string or function, -- Specifies code to run after this plugin is loaded.
--   -- The setup key implies opt = true
--   setup = string or function,  -- Specifies code to run before this plugin is loaded.
--   -- The following keys all imply lazy-loading and imply opt = true
--   cmd = string or list,        -- Specifies commands which load this plugin. Can be an autocmd pattern.
--   ft = string or list,         -- Specifies filetypes which load this plugin.
--   keys = string or list,       -- Specifies maps which load this plugin. See "Keybindings".
--   event = string or list,      -- Specifies autocommand events which load this plugin.
--   fn = string or list          -- Specifies functions which load this plugin.
--   cond = string, function, or list of strings/functions,   -- Specifies a conditional test to load this plugin
--   module = string or list      -- Specifies Lua module names for require. When requiring a string which starts
--                                -- with one of these module names, the plugin will be loaded.
--   module_pattern = string/list -- Specifies Lua pattern of Lua module names for require. When requiring a string which matches one of these patterns, the plugin will be loaded.
-- }
--

use({ "dccsillag/magma-nvim", run = ":UpdateRemotePlugins" })

---------- AUTO INSTALLERS START ----------
use({ "williamboman/mason.nvim" })

use({ "jayp0521/mason-null-ls.nvim" })

use({
	"jose-elias-alvarez/null-ls.nvim",
	config = function()
		require("lsp.null-ls")
	end,
})

use({ "williamboman/mason-lspconfig.nvim" })

use({
	"neovim/nvim-lspconfig",
	config = function()
		require("lsp")
	end,
	after = {
		"mason.nvim",
		"mason-lspconfig.nvim",
	},
})
---------- AUTO INSTALLERS START ----------

use("wellle/targets.vim")

use({
	"sidebar-nvim/sidebar.nvim",
	config = function()
		require("plugin.sidebar.init")
	end,
})

use({
	"rcarriga/nvim-notify",
	config = function()
		require("plugin.notify")
	end,
})
-- use({
--   "kevinhwang91/nvim-bqf",
--   ft = "qf",
--   config = function()
--     require("plugin.bqf")
--   end,
-- })

use({
	"kylechui/nvim-surround",
	config = function()
		require("plugin.surround")
	end,
})

use("skywind3000/asyncrun.vim")
use({
	"akinsho/bufferline.nvim",
	config = function()
		require("plugin.bufferline")
	end,
})
use("https://github.com/moll/vim-bbye")

use({
	"michaelb/sniprun",
	config = function()
		require("plugin.sniprun.setup")
	end,
	run = "bash ./install.sh",
})

use({
	"norcalli/nvim-colorizer.lua",
})

use({
	"nvim-lualine/lualine.nvim",
	after = "nvim-base16",
	requires = {
		{ "kyazdani42/nvim-web-devicons" },
		{ "RRethy/nvim-base16" },
	},
	config = function()
		require("plugin/lualine")
	end,
})

--use {
--  'pwntester/octo.nvim',
--  requires = {
--    'nvim-lua/plenary.nvim',
--    'nvim-telescope/telescope.nvim',
--    'kyazdani42/nvim-web-devicons',
--  },
--  config = function()
--    require "plugin.octo"
--  end
--}

-- use("nvim-lua/popup.nvim")

use({
	"kwkarlwang/bufresize.nvim",
	config = function()
		require("plugin/bufresize")
	end,
})

use({
	"nvim-pack/nvim-spectre",
	config = function()
		require("plugin.spectre")
	end,
})

use({
	"rafcamlet/nvim-luapad",
	config = function() --require "plugin.luapad"
	end,
})

use({
	"ray-x/lsp_signature.nvim",
	config = function()
		require("lsp.signature")
	end,
}) -- auto floating signature help - nvim compe doesnt support

use("nvim-lua/lsp-status.nvim")
use("nvim-telescope/telescope-ui-select.nvim")
use("nvim-telescope/telescope-live-grep-args.nvim")

-- cmp lsp

use("rafamadriz/friendly-snippets")

use({
	"windwp/nvim-autopairs",
	config = function()
		require("plugin.nvim-autopairs")
	end,
})

use({
	"numToStr/Comment.nvim",
	config = function()
		require("plugin.comment")
	end,
})

use("jbyuki/nabla.nvim")

-- use({
--   "nvim-neorg/neorg",
--   --commit = "36bffcb37e0d9ae5bec069e13bea22840f1a5aa3",
--   commit = "09eee9da00f61c7d1202d1f22c44db549ddfdc81",
--   --commit = "633dfc9f0c3a00a32ee89d4ab826da2eecfe9bd8",
--   config = function()
--     require("plugin.neorg.init")
--   end,
--   after = "nvim-treesitter",
--   version = "0.0.11",
--   requires = {
--     "nvim-lua/plenary.nvim",
--     "vhyrro/neorg-telescope",
--   },
-- })

use({
	"nvim-neorg/neorg",
	config = function()
		require("plugin.neorg.init")
	end,
	requires = "nvim-lua/plenary.nvim",
})

use({
	"sudormrfbin/cheatsheet.nvim",
	config = function()
		require("plugin.cheatsheet")
	end,
	requires = {
		{ "nvim-telescope/telescope.nvim" },
		{ "nvim-lua/popup.nvim" },
		{ "nvim-lua/plenary.nvim" },
	},
})

use({ "ellisonleao/glow.nvim", run = "GlowInstall" })

use("honza/vim-snippets")
-- use({
--   "akinsho/toggleterm.nvim",
--   config = function()
--     require("plugin.toggleterm")
--   end,
-- })

use("stsewd/sphinx.nvim")

-- use({ "voldikss/vim-floaterm", opt = true })

-- use("lambdalisue/glyph-palette.vim")
-- use("ryanoasis/vim-devicons")
-- use("tjdevries/colorbudnvim-bufferline.lua",dy.nvim")

--use("xiyaowong/nvim-transparent")

use("folke/neoscroll.nvim")
use("folke/todo-comments.nvim")
use("folke/ultra-runner")
use("folke/persistence.nvim")
use("folke/twilight.nvim")

use({
	"weilbith/nvim-code-action-menu", -- lsp/init needs to require it
	--cmd = 'CodeActionMenu',
})

use("MunifTanjim/nui.nvim")

use({
	"simrat39/symbols-outline.nvim",
	cmd = { "SymbolsOutline" },
})

use({ "nvim-treesitter/playground", cmd = "TSHighlightCapturesUnderCursor" })
--use("nvim-treesitter/nvim-treesitter-refactor")
use("nvim-treesitter/nvim-treesitter-textobjects")
use("nvim-treesitter/nvim-treesitter-context")
use("RRethy/nvim-treesitter-textsubjects")

-- telescope extensions
use("nvim-telescope/telescope-cheat.nvim")
use("dhruvmanila/telescope-bookmarks.nvim")
use("nvim-telescope/telescope-symbols.nvim")
use("nvim-telescope/telescope-github.nvim")
use("nvim-telescope/telescope-fzf-writer.nvim")

--use("tpope/vim-fugitive")

use({
	"ahmedkhalf/project.nvim",
	config = function()
		require("plugin.project")
	end,
})
-- indent guides and rainbow bracket
use({
	"lukas-reineke/indent-blankline.nvim",
	config = function()
		require("plugin.blankline")
	end,
})

-- git
use({
	"sindrets/diffview.nvim",
	cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles" },
	config = function()
		require("plugin.diffview")
	end,
})

use({
	"folke/trouble.nvim",
	event = "BufReadPre",
	wants = "nvim-web-devicons",
	cmd = { "TroubleToggle", "Trouble" },
	config = function()
		require("plugin.trouble")
	end,
})

use({
	"TimUntersberger/neogit",
	cmd = "Neogit",
	config = function() end,
})

use({
	"lewis6991/gitsigns.nvim",
	event = "BufReadPre",
	wants = "plenary.nvim",
	requires = { "nvim-lua/plenary.nvim" },
	config = function()
		--require("config.gitsigns")
	end,
})

use("ibhagwan/fzf-lua")
use("vijaymarupudi/nvim-fzf")

use("nanotee/luv-vimdocs")

use({
	"folke/which-key.nvim",
	config = function()
		require("keymap")
	end,
})

-- syntax highlighting
use("kmonad/kmonad-vim")
use("fladson/vim-kitty")
use("direnv/direnv.vim")
use("mboughaba/i3config.vim")
use("Fymyte/rasi.vim")
-- syntax highlighting (from vim-polyglot list)
-- https://github.com/sheerun/vim-polyglot
use("MTDL9/vim-log-highlighting")
use("baskerville/vim-sxhkdrc")

use("tpope/vim-unimpaired")

use({
	"norcalli/nvim-terminal.lua",
	ft = "terminal",
	config = function()
		require("terminal").setup()
	end,
})

use({
	"stevearc/dressing.nvim",
	config = function()
		require("plugin.dressing")
	end,
})
use({
	"mrjones2014/legendary.nvim",
	config = function()
		require("plugin.legendary")
	end,
})

---------- LSP - all req plugs in lsp config files  ----------

-- ray-x navigator
use({ "ray-x/guihua.lua", run = "cd lua/fzy && make" })
-- use({ 'ray-x/navigator.lua' })

use({ "simrat39/rust-tools.nvim" })

use({
	"hrsh7th/nvim-cmp",
	--event = "InsertEnter",
	config = function()
		require("lsp/cmp")
	end,
	--wants = { "LuaSnip" },
})

use("hrsh7th/cmp-nvim-lsp")
use("hrsh7th/cmp-nvim-lua")
use("saadparwaiz1/cmp_luasnip")
use("hrsh7th/cmp-buffer")
use("hrsh7th/cmp-path")
use("quangnguyen30192/cmp-nvim-tags")

use({
	"L3MON4D3/LuaSnip",
	wants = "friendly-snippets",
	config = function()
		require("plugin.luasnip")
	end,
})

use("folke/lua-dev.nvim") -- plugin and nvim api hover docs for lua lsp

use("dcampos/cmp-snippy")

use({
	"dcampos/nvim-snippy",
	config = function()
		require("plugin.snippy.setup")
	end,
})

use("tridactyl/vim-tridactyl")

use({
	"iamcco/markdown-preview.nvim",
	run = function()
		vim.fn["mkdp#util#install"]()
	end,
})

use({
	"RRethy/nvim-base16",
	config = function()
		require("colorscheme")
	end,
})

use({
	"mfussenegger/nvim-dap",
	config = function()
		require("plugin.dap")
	end,
	after = { "nvim-dap-python", "nvim-dap-ui" },
})
use("mfussenegger/nvim-dap-python")
use({ "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } })

use({
	"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
	config = function()
		require("lsp_lines").setup()
		require("lsp_lines").toggle()
	end,
})

use({
	"gelguy/wilder.nvim",
	config = function()
		require("plugin.wilder")
	end,
})

use({
	"ThePrimeagen/git-worktree.nvim",
	config = function()
		require("plugin.git-worktree")
	end,
})

-- https://github.com/tjdevries/sg.nvim/issues/4
-- use({
	-- "tjdevries/sg.nvim",
  -- config = function() 
  -- end,
-- })

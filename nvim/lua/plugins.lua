local execute = vim.api.nvim_command

local fn = vim.fn

--local install_path = fn.stdpath("data") .. "/site/pack/packer/opt/packer.nvim"
local me = _G.f.dev_cl .. "/lua/me-plug"
local forks = _G.f.dev_cl .. "/lua/fork-plug"


vim.cmd([[packadd packer.nvim]])
return require("packer").startup(function(use)
  use({
    "GustavoKatel/sidebar.nvim",
    config = function()
      require("plugin.sidebar.init")
    end,
  })
  --use  { forks .. '/nui.nvim' } --use 'MunifTanjim/nui.nvim'
  --use { forks .. '/telescope-frecency.nvim'}
  use("fhill2/nui.nvim")

  use({ 
    "kevinhwang91/nvim-bqf", 
  ft = "qf", 
  config = function() 
   require("plugin.bqf")
  end,
 })

  use({ "wbthomason/packer.nvim", opt = true })

  use({'simrat39/rust-tools.nvim'})

  use("skywind3000/asyncrun.vim")
  use({
    "akinsho/nvim-bufferline.lua",
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
    run = 'bash ./install.sh'
  })

  use({
    "norcalli/nvim-colorizer.lua",
    config = function() require'colorizer'.setup() end,
})
  -- use {
  --    'glepnir/galaxyline.nvim',
  --     branch = 'main'
  --     -- requires = {'kyazdani42/nvim-web-devicons', opt = true}
  --   }


  -- use({
  --   "glepnir/galaxyline.nvim",
  --   branch = "main",
  --   config = function()
  --     require("plugin.galaxyline.vinod")
  --   end,
  --   -- your statusline
  --   --config = function() require'my_statusline' end,
  --   -- some optional icons
  --   requires = { "kyazdani42/nvim-web-devicons", opt = true },
  -- })
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    config = function() require("plugin/lualine") end

  }

  --use 'hoob3rt/lualine.nvim'
  --use("sayanarijit/xplr.vim")
  use("nvim-lua/popup.nvim")
  use("nvim-lua/plenary.nvim")

  --use("tpope/vim-fugitive")

  use({
    "windwp/nvim-spectre",
    opt = true,
    module = "spectre",
    wants = { "plenary.nvim", "popup.nvim" },
    requires = { "nvim-lua/popup.nvim", "nvim-lua/plenary.nvim" },
  })

  --use({ "prettier/vim-prettier", run = "npm install" })
  use({
    "rafcamlet/nvim-luapad",
    config = function() --require "plugin.luapad"
    end,
  })
  use("metakirby5/codi.vim")
  use("svermeulen/vimpeccable")
  --use 'bfredl/nvim-luadev'
  use("tjdevries/nlua.nvim")

  use({ me .. "/omnimenu.nvim" })
  --use 'fhill2/omnimenu.nvim'

  use("ray-x/lsp_signature.nvim") -- auto floating signature help - nvim compe doesnt support
  use({
    "onsails/lspkind-nvim",
    config = function()
      require("lsp.kind")
    end,
  }) -- add vscode icons to dropdown
  use("tjdevries/lsp_extensions.nvim")
  use("tami5/lspsaga.nvim")

  use("nvim-telescope/telescope-file-browser.nvim")
  -- use({
  --   "kosayoda/nvim-lightbulb",
  --   config = function()
  --     require("lsp.lightbulb")
  --   end,
  -- })
  use("nvim-lua/lsp-status.nvim")
  use("folke/lua-dev.nvim") -- plugin and nvim api hover docs for lua lsp

  -- cmp lsp

  use({
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    opt = true,
    config = function()
      require("lsp/cmp")
    end,
    wants = { "LuaSnip" },
    requires = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "quangnguyen30192/cmp-nvim-tags",
      "dcampos/cmp-snippy",
      {
        "L3MON4D3/LuaSnip",
        wants = "friendly-snippets",
        config = function()
          require("plugin.luasnip")
        end,
      },
      "rafamadriz/friendly-snippets",
      {
        "windwp/nvim-autopairs",
        config = function()
          require("nvim-autopairs")
        end,
      },
    },
  })

  -- ray-x navigator
  use({'ray-x/guihua.lua', 
    run = 'cd lua/fzy && make'
  })
  use({'ray-x/navigator.lua',
    config = function() 
          require("lsp.navigator")
    end,
  })

  -- compe lsp (deprecated)
  --use 'tamago324/compe-zsh' -- zsh completions
  --use 'hrsh7th/nvim-compe'
  -- use({
  --   "kristijanhusak/orgmode.nvim",
  --   config = function()
  --     require("plugin.orgmode")
  --   end,
  -- })

  use('jbyuki/nabla.nvim')

  use({
    "nvim-neorg/neorg",
    --commit = "36bffcb37e0d9ae5bec069e13bea22840f1a5aa3",
    commit = "09eee9da00f61c7d1202d1f22c44db549ddfdc81",
    --commit = "633dfc9f0c3a00a32ee89d4ab826da2eecfe9bd8",
    config = function()
      require("plugin.neorg.init")
    end,
    after = "nvim-treesitter",
    version = "0.0.11",
    requires = {
      "nvim-lua/plenary.nvim",
      "vhyrro/neorg-telescope",
    },
  })

  -- use({
  --   "oberblastmeister/neuron.nvim",
  --   config = function()
  --     require("plugin.neuron")
  --   end,
  --   requires = {
  --     "nvim-lua/popup.nvim",
  --     "nvim-lua/plenary.nvim",
  --     "nvim-telescope/telescope.nvim",
  --   },
  -- })

  -- use({
  --   "iamcco/markdown-preview.nvim",
  --   run = { "cd app & yarn install" },
  --   config = function()
  --     require("plugin.markdown-preview")
  --   end,
  -- })

  use({ "npxbr/glow.nvim", run = "GlowInstall" })

  -- snippets
  use({
    "dcampos/nvim-snippy",
    config = function() require("plugin.snippy.setup") end
    })
  --use { forks .. "/nvim-snippy" }

  --use 'SirVer/ultisnips'

  use("honza/vim-snippets")
  use({
    "akinsho/nvim-toggleterm.lua",
    config = function()
      require("plugin.toggleterm")
    end,
  })

  use("stsewd/sphinx.nvim")
  --use("theHamsta/nvim-dap-virtual-text")
  use({
    "hkupty/iron.nvim",
    config = function()
      require("plugin.iron")
    end,
  })
  --use { me ..  '/codelibrary.nvim' }
  use({ "voldikss/vim-floaterm", opt = true })

  --use { forks .. '/nvim-tree.lua' }
  use("lambdalisue/nerdfont.vim")
  use("lambdalisue/glyph-palette.vim")
  use("ryanoasis/vim-devicons")
  use({ "kyazdani42/nvim-web-devicons", opt = false })
  use("tjdevries/colorbuddy.vim")

  use({
    "folke/tokyonight.nvim",
    config = function()
      require("plugin.tokyonight")
    end,
  })

  --use("ms-jpq/neovim-async-tutorial")
  use("folke/neoscroll.nvim")
  use("folke/todo-comments.nvim")
  use("folke/ultra-runner")
  use("folke/persistence.nvim")
  use("folke/twilight.nvim")

  use("kevinhwang91/rnvimr")

  use({
    "neovim/nvim-lspconfig",
    opt = false,
    --event = "BufReadPre",
    --wants = { "nvim-lsp-ts-utils", "null-ls.nvim", "lua-dev.nvim" },
    config = function()
      require("lsp")
    end,
    requires = {
      "jose-elias-alvarez/nvim-lsp-ts-utils",
      "jose-elias-alvarez/null-ls.nvim",
      "folke/lua-dev.nvim",
    },
  })


  use({
    'weilbith/nvim-code-action-menu',
    cmd = 'CodeActionMenu',
  })

  use({ "jose-elias-alvarez/null-ls.nvim",
    config = function()
      require("lsp.null-ls.init")
  end
  })

  -- overrides all other virtual text
  -- use({
  --   "keyvchan/virt_context.nvim",
  --   config = function() require("plugin/virt-context") end,
  -- })

  
  use({
    "simrat39/symbols-outline.nvim",
    cmd = { "SymbolsOutline" },
  })

  use({
    "b3nj5m1n/kommentary",
    opt = true,
    wants = "nvim-ts-context-commentstring",
    keys = { "gc", "gcc" },
    config = function()
      require("plugin.kommentary")
    end,
    requires = "JoosepAlviste/nvim-ts-context-commentstring",
  })

  use({
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    --cmd = { "TSInstall", "TSInstallInfo", "TSTSBufEnable", "TSBufDisable", "TSEnableAll", "TSDisableAll", "TSModuleInfo" },
    opt = false,
    --event = "BufRead",
    requires = {
      { "nvim-treesitter/playground", cmd = "TSHighlightCapturesUnderCursor" },
      "nvim-treesitter/playground",
      "nvim-treesitter/nvim-treesitter-refactor",
      "nvim-treesitter/nvim-treesitter-textobjects",
      "romgrk/nvim-treesitter-context",
      "RRethy/nvim-treesitter-textsubjects",
      "p00f/nvim-ts-rainbow",
    },
    config = function() 
      require('plugin.treesitter') 
    end,
  })

  use({
    "norcalli/nvim-terminal.lua",
    ft = "terminal",
    config = function()
      require("terminal").setup()
    end,
  })
  use({
    "kyazdani42/nvim-tree.lua",
    requires = "kyazdani42/nvim-web-devicons",
    config = function()
      require("plugin.nvim-tree")
    end,
  })

  use({
    --forks .. "/telescope.nvim",
    "nvim-telescope/telescope.nvim",
    opt = false,
    config = function()
      require("plugin.telescope.init")
    end,
    --cmd = { "Telescope" },
    --module = "telescope",
    --keys = { "<leader><space>", "<leader>fz", "<leader>pp" },
    -- wants = {
    --   "plenary.nvim",
    --   "popup.nvim",
    --   "telescope-fzy-native.nvim",
    --   "telescope-project.nvim",
    --   "trouble.nvim",
    --   "telescope-symbols.nvim",
    --   "nvim-web-devicons",
    --   --"telescope-zoxide.nvim",
    --   "telescope-repo.nvim",
    -- },
    requires = {
      "nvim-telescope/telescope-cheat.nvim",
      "dhruvmanila/telescope-bookmarks.nvim",
      "nvim-telescope/telescope-project.nvim",
      "nvim-lua/popup.nvim",
      "cljoly/telescope-repo.nvim",
      "nvim-telescope/telescope-fzf-native.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-symbols.nvim",
      "nvim-telescope/telescope-fzy-native.nvim",
      --"jvgrootveld/telescope-zoxide",
      "nvim-telescope/telescope-frecency.nvim",
      "project.nvim",
    },
  })

  use("jvgrootveld/telescope-zoxide")

  use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })

  -- use({
  --   "nvim-telescope/telescope-fzf-native.nvim",
  --   after = "telescope.nvim",
  --   setup = function()
  --     require("telescope").load_extension("fzf")
  --   end,
  -- })

  use({
    "cljoly/telescope-repo.nvim",
    --after = "telescope.nvim",
    --setup = function()
    --  require("telescope").load_extension("repo")
    --end,
  })
  use({
    "nvim-telescope/telescope-frecency.nvim",
    requires = "tami5/sqlite.lua",
    -- setup = function()
    --   require("telescope").load_extension("frecency")
    -- end,
  })

  use({
    "ahmedkhalf/project.nvim",
    config = function()
      require("plugin.project")
    end,
  })
  -- indent guides and rainbow bracket
  use({
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPre",
    config = function()
      print("indent blankline")
      require("plugin..blankline")
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
  -- sort out
  use({
    me .. "/xplr.nvim",
    config = function()
      require("plugin.xplr")
    end,
    requires = { { "fhill2/telescope.nvim" } },
  })
  use("mboughaba/i3config.vim")

  use({
    "folke/which-key.nvim",
    config = function()
      require("plugin.whichkey")
      require("keymap")
    end,
  })

  -- syntax highlighting
  use("kmonad/kmonad-vim")
  use("fladson/vim-kitty")

  use("tpope/vim-unimpaired")

  -- better paste indentation - overrides p and P
  --  use("sickill/vim-pasta")
  -- deprecated - dont use anymore
  --use("rktjmp/fwatch.nvim")
  -- deprecated since nixOS
  --use("kabouzeid/nvim-lspinstall")
  --use("justinmk/lua-client2")
  --use("GustavoKatel/telescope-asynctasks.nvim")

  --use("skywind3000/asynctasks.vim")
  --use 'mhartington/formatter.nvim'

  --use("lambdalisue/vim-gita")
  -- try these out
  --andymass/vim-matchup
  --https://github.com/RRethy/vim-illuminate
end)

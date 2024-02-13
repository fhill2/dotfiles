return {
    {"theprimeagen/harpoon"},
    {"williamboman/mason.nvim"},
    {"williamboman/mason-lspconfig.nvim"},
    {"neovim/nvim-lspconfig"},
    {
        "michaelb/sniprun",
        build = "sh install.sh",    
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' }
    },
    -- {"kwkarlwang/bufresize.nvim"},
    {"windwp/nvim-autopairs"},
    {"numToStr/Comment.nvim"},
    {"kosayoda/nvim-lightbulb"},
    {"lukas-reineke/indent-blankline.nvim"},
    {"sindrets/diffview.nvim"},
    {"TimUntersberger/neogit"},
    {"folke/trouble.nvim"},
    {"lewis6991/gitsigns.nvim"},
    {"kmonad/kmonad-vim"},
    {"fladson/vim-kitty"},
    {"direnv/direnv.vim"},
    {"mboughaba/i3config.vim"},
    {"Fymyte/rasi.vim"},
    {"nikvdp/ejs-syntax"},
    {"hrsh7th/nvim-cmp"},
    {"ThePrimeagen/git-worktree.nvim"},
    {"nvim-treesitter/nvim-treesitter"},
    { "catppuccin/nvim", name = "catppuccin", priority = 1000, config = function() -- setup must be called before loading
        vim.cmd.colorscheme "catppuccin" end },
    {'stevearc/overseer.nvim'},
    { 
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-treesitter/nvim-treesitter",
        }
    },
    {"mikesmithgh/kitty-scrollback.nvim"},
    {
    'chomosuke/term-edit.nvim',
    ft = "toggleterm",
    version = '1.*',
    },
    {"mateuszwieloch/automkdir.nvim"},
    {
    "neovim/nvim-lspconfig",
    dependencies = {
        {
            "SmiteshP/nvim-navbuddy",
            dependencies = {
                "SmiteshP/nvim-navic",
                "MunifTanjim/nui.nvim"
            },
            opts = { lsp = { auto_attach = true } }
        }
    },
    -- your lsp config or other stuff
    },
    {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = {
        "SmiteshP/nvim-navic",
        "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    },
    {
        "roobert/surround-ui.nvim",
        dependencies = {
        "kylechui/nvim-surround",
        "folke/which-key.nvim",
        },
    config = function()
        require("surround-ui").setup({
        root_key = "S"
    })
    end,
    },
    {"ldelossa/litee.nvim"},
    {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
        "MunifTanjim/nui.nvim",
        "rcarriga/nvim-notify",
    }
    },
    {
    {
        "willothy/flatten.nvim",
        config = true,
        lazy = false,
        priority = 1001,
    },
    },
    {
    "roobert/action-hints.nvim",
    config = function()
        require("action-hints").setup()
    end,
    },
    { "stevanmilic/nvim-lspimport" },
}
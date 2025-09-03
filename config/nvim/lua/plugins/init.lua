return {
  { "aliou/bats.vim" },
  { "sindrets/diffview.nvim" },
  { "nvim-telescope/telescope.nvim" },
  -- {
  --   "mikesmithgh/kitty-scrollback.nvim",
  --   enabled = true,
  --   lazy = true,
  --   cmd = { "KittyScrollbackGenerateKittens", "KittyScrollbackCheckHealth" },
  --   event = { "User KittyScrollbackLaunch" },
  --   -- version = '*', -- latest stable version, may have breaking changes if major version changed
  --   -- version = '^4.0.0', -- pin major version, include fixes and features that do not have breaking changes
  --   config = function()
  --     require("kitty-scrollback").setup()
  --   end,
  -- },
  -- { "fhill2/telescope-ultisnips.nvim" },
  -- { "SirVer/ultisnips" },
  -- { "honza/vim-snippets" },
  -- { "nvim-treesitter/nvim-treesitter", lazy = false },
  {
    "nvim-neotest/neotest",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    keys = {
      {
        "<leader>tw",
        function()
          require("neotest").watch.watch()
        end,
        desc = "Neotest - Watch",
      },
      {
        "<leader>tW",
        function()
          require("neotest").watch.toggle()
        end,
        desc = "Neotest - Watch toggle",
      },
    },
  },
  {
    "michaelb/sniprun",
    branch = "master",

    build = "sh install.sh",
    -- do 'sh install.sh 1' if you want to force compile locally
    -- (instead of fetching a binary from the github release). Requires Rust >= 1.65

    config = function()
      require("sniprun").setup({
        interpreter_options = {
          Rust_original = {
            compiler = "rustc",
          },
        },
      })
    end,
  },
  { "bfontaine/Brewfile.vim" },
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      bigfile = { enabled = true },
      dashboard = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = false },
      -- https://github.com/folke/snacks.nvim/blob/main/docs/statuscolumn.md
      -- default statuscolumn config
      -- something is erroring in the statuscolumn default lazynvim config
      -- statuscolumn = {
      --   left = { "mark", "sign" }, -- priority of signs on the left (high to low)
      --   right = { "fold", "git" }, -- priority of signs on the right (high to low)
      --   folds = {
      --     open = false, -- show open fold icons
      --     git_hl = false, -- use Git Signs hl for fold icons
      --   },
      --   git = {
      --     -- patterns to match Git signs
      --     patterns = { "GitSign", "MiniDiffSign" },
      --   },
      --   refresh = 50, -- refresh at most every 50ms
      -- },
      words = { enabled = true },
    },
  },
  {
    "m00qek/baleia.nvim",
    version = "*",
    config = function()
      vim.g.baleia = require("baleia").setup({})

      -- Command to colorize the current buffer
      vim.api.nvim_create_user_command("BaleiaColorize", function()
        vim.g.baleia.once(vim.api.nvim_get_current_buf())
      end, { bang = true })

      -- Command to show logs
      vim.api.nvim_create_user_command("BaleiaLogs", vim.g.baleia.logger.show, { bang = true })
    end,
  },
  {
    "mozanunal/sllm.nvim",
    dependencies = {
      "echasnovski/mini.notify",
      "echasnovski/mini.pick",
    },
    config = function()
      require("sllm").setup({
        keymaps = {
          ask_llm = "<localleader>s",
        },
      })
    end,
  },
}

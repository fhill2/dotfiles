return {
  {"aliou/bats.vim"},
  { "sindrets/diffview.nvim" },
  {"nvim-telescope/telescope.nvim"},
  {
    "mikesmithgh/kitty-scrollback.nvim",
    enabled = true,
    lazy = true,
    cmd = { "KittyScrollbackGenerateKittens", "KittyScrollbackCheckHealth" },
    event = { "User KittyScrollbackLaunch" },
    -- version = '*', -- latest stable version, may have breaking changes if major version changed
    -- version = '^4.0.0', -- pin major version, include fixes and features that do not have breaking changes
    config = function()
      require("kitty-scrollback").setup()
    end,
  },
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
  { "bfontaine/Brewfile.vim" },
}

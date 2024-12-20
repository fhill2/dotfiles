return {
  { "aliou/bats.vim" },
  { "sindrets/diffview.nvim" },
  { "nvim-telescope/telescope.nvim" },
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
}

return {
  { "nvimdev/dashboard-nvim", enabled = false },
  -- these keybindings override my  user defined keymaps [t ]t in config/keymaps.lua ??
  -- so I've disabled it for now...
  { "folke/todo-comments.nvim", enabled = false },
  -- causes noice.nvim custom search ui to exit insert mode prematurely
  { "folke/flash.nvim", enabled = false },
  { "lewis6991/gitsigns.nvim", enabled = false },

  -- mason-lspconfig.nvim
  -- The desired behaviour is to not install rust_analyzer
  -- but install all other LSPs
  -- and I cannot get this configuration working
  { "williamboman/mason-lspconfig.nvim", enabled = false },
}

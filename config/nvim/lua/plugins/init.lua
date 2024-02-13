return {
  { "sindrets/diffview.nvim" },
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
  {
    "sindrets/winshift.nvim",
    keys = {
      -- Start Win-Move mode:
      { "<C-W><C-M>", "<Cmd>WinShift<CR>", { noremap = true } },
      { "<C-W>m", "<Cmd>WinShift<CR>", { noremap = true } },
      -- Swap two windows:
      { "<C-W>X", "<Cmd>WinShift swap<CR>", { noremap = true } },
      -- I have remapped the window focus builtints  to <C-hjkl>
      -- so these default keys can be used by WinShift
      { "<C-w>h", "<Cmd>WinShift left<CR>", { noremap = true } },
      { "<C-w>j", "<Cmd>WinShift down<CR>", { noremap = true } },
      { "<C-w>k", "<Cmd>WinShift up<CR>", { noremap = true } },
      { "<C-w>l", "<Cmd>WinShift right<CR>", { noremap = true } },
      { "<C-w>H", "<Cmd>WinShift far_left<CR>", { noremap = true } },
      { "<C-w>J", "<Cmd>WinShift far_down<CR>", { noremap = true } },
      { "<C-w>K", "<Cmd>WinShift far_up<CR>", { noremap = true } },
      { "<C-w>L", "<Cmd>WinShift far_right<CR>", { noremap = true } },
    },
  },
}

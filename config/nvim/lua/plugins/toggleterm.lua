local Util = require("lazyvim.util")
return {
  "akinsho/toggleterm.nvim",
  lazy = true,
  cmd = { "ToggleTerm" },
  keys = {
    {
      "<leader>tf",
      function()
        local count = vim.v.count1
        require("toggleterm").toggle(count, 0, Util.root.get(), "float")
      end,
      desc = "ToggleTerm (float root_dir)",
    },
    {
      "<leader>th",
      function()
        local count = vim.v.count1
        require("toggleterm").toggle(count, 15, Util.root.get(), "horizontal")
      end,
      desc = "ToggleTerm (horizontal root_dir)",
    },
    {
      "<leader>tv",
      function()
        local count = vim.v.count1
        require("toggleterm").toggle(count, vim.o.columns * 0.4, Util.root.get(), "vertical")
      end,
      desc = "ToggleTerm (vertical root_dir)",
    },
    {
      "<leader>tn",
      "<cmd>ToggleTermSetName<cr>",
      desc = "Set term name",
    },
    {
      "<leader>ts",
      "<cmd>TermSelect<cr>",
      desc = "Select term",
    },
    {
      "<leader>tt",
      function()
        require("toggleterm").toggle(1, 100, Util.root.get(), "tab")
      end,
      desc = "ToggleTerm (tab root_dir)",
    },
  },
  opts = {
    -- the opts listed on toggleterm.nvim github are not defaults
    -- open_mapping = [[<C-\>]],
    -- winbar = { enabled = true },
    -- size = 35,
  },
}

-- version = "*",
-- config = function()
--   -- https://sourcegraph.com/github.com/LunarVim/Neovim-from-scratch@55d29f82613aeeb755cbd3c62c46b8c24e2045d4/-/blob/lua/user/toggleterm.lua
--   local Terminal = require("toggleterm.terminal").Terminal
--   _T1 = Terminal:new({
--     cmd = "",
--     size = 40,
--     direction = "horizontal",
--     hidden = true,
--   })
--   -- function _T1_TOGGLE()
--   -- t1:toggle()
--   -- end
--   vim.keymap.set("n", "<leader>tt", function()
--     _T1:toggle()
--   end)
-- end,

local Util = require("lazyvim.util")
return {
  "akinsho/toggleterm.nvim",
  lazy = true,
  cmd = { "ToggleTerm" },
  keys = {
    -- {
    --   "<leader>of",
    --   function()
    --     local count = vim.v.count1
    --     require("toggleterm").toggle(3, 0, Util.root.get(), "float")
    --   end,
    --   desc = "ToggleTerm (float root_dir)",
    -- },
    -- {
    --   "<leader>os",
    --   function()
    --     local count = vim.v.count1
    --     require("toggleterm").toggle(2, 40, Util.root.get(), "horizontal")
    --   end,
    --   desc = "ToggleTerm (horizontal root_dir)",
    -- },
    -- {
    --   "<leader>ov",
    --   function()
    --     local count = vim.v.count1
    --     require("toggleterm").toggle(1, vim.o.columns * 0.4, Util.root.get(), "vertical")
    --   end,
    --   desc = "ToggleTerm (vertical root_dir)",
    -- },
    -- {
    --   "<leader>on",
    --   "<cmd>ToggleTermSetName<cr>",
    --   desc = "Set term name",
    -- },
    -- TODO: this hotkey shows a popup window that lists all terminals, on focus it focuses the terminal
    -- change this functionality to a hotkey that focuses between all terminals without the popup
    -- {
    --   "<leader>os",
    --   "<cmd>TermSelect<cr>",
    --   desc = "Select term",
    -- },
    -- {
    --   "<leader>ot",
    --   function()
    --     require("toggleterm").toggle(1, 100, Util.root.get(), "tab")
    --   end,
    --   desc = "ToggleTerm (tab root_dir)",
    -- },
    -- set a command to toggle only the first terminal
    -- TODO: make this support multiple terminals, remembering the last focused terminal
    -- {
    --   "<leader>y",
    --   function()
    --     -- https://github.com/akinsho/toggleterm.nvim/issues/42#issuecomment-944902771
    --     -- TODO: creater a newer version of the above link
    --     -- toggleterm only saves the previously entered terminal when the terminals are closed
    --     -- could add an autocmd to save the terminals when entering?
    --     require("toggleterm.terminal").get(1):focus()
    --   end,
    --   desc = "Focus ToggleTerm 1",
    -- },
    {
      "<C-\\>",
      function()
        cmd = table.concat({ vim.bo.filetype, vim.fn.expand("%") }, " ")
        require("toggleterm").exec(cmd, 1, _, _, _, _, true, true)
      end,
      desc = "Run File in Terminal",
    },

    -- https://github.com/LazyVim/LazyVim/discussions/2559
    -- lazyvim/config/keymaps.lua:143
    -- lazyvim sets <C-/> to open and close a lazyvim floating terminal that cannot be configured
    -- however, I keep the lazygit floating terminal mappings
    --
    { "<C-/>", "<cmd>ToggleTerm<cr>", desc = "Open ToggleTerm" },
  },
  opts = {
    -- the opts listed on toggleterm.nvim github are not defaults
    open_mapping = [[<C-/>]],
    -- winbar = { enabled = true },
    direction = "horizontal",
    size = 40,
    winbar = {
      -- so I can see the count / index of the terminal to perform operations on
      enabled = true,
    },
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

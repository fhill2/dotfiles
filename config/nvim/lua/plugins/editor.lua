return {
  {
    "folke/todo-comments.nvim",
    keys = {
      -- Im using [t ]t for tabprev tabnext
      -- { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      -- { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
    },
  },
  -- {
  --   "nvim-lualine/lualine.nvim",
  --   opts = function(_, opts)
  --     opts.sections.lualine_c[4] = {
  --       function()
  --         return vim.fn.expand("%:p")
  --       end,
  --     }
  --     return opts
  --   end,
  -- },
}

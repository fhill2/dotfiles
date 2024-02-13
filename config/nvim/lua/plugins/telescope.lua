return {

  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
      },
    },
    keys = {
      {
        "<leader>fg",
        function()
          require("telescope.builtin").find_files()
        end,
        desc = "Find Files - Git Ignore",
      },
      {
        "<leader>fb",
        function()
          require("telescope").extensions.file_browser.file_browser({
            path = vim.fn.expand("%:p:h"),
            select_buffer = true,
          })
        end,
        desc = "File Browser - Buffer",
      },
      {
        "<leader>fd",
        function()
          require("telescope").extensions.file_browser.file_browser()
        end,
        desc = "File Browser",
      },
      {
        "<leader>fv",
        function()
          require("telescope").extensions.file_browser.file_browser({ cwd = vim.loop.os_homedir() .. "/dot" })
        end,
        desc = "File Browser - ~/dot",
      },
      {
        "<leader>fc",
        function()
          require("telescope").extensions.file_browser.file_browser({ cwd = vim.fn.stdpath("config") })
        end,
        desc = "Find Config File",
      },
    },
    config = function()
      local fb_actions = require("telescope").extensions.file_browser.actions
      require("telescope").setup({
        extensions = {
          file_browser = {
            depth = 1, -- start at depth 1
            auto_depth = true, -- when starting to type, show all depths
            respect_gitignore = false,
            mappings = {
              ["i"] = {
                ["<A-c>"] = false, -- create
                ["<A-r>"] = false, -- rename
                ["<A-y>"] = false, -- copy
                ["<A-d>"] = false, -- remove
                ["<A-m>"] = false, -- move
                ["<C-[>"] = require("telescope.actions.layout").cycle_layout_prev,
                ["<C-]>"] = require("telescope.actions.layout").cycle_layout_next,
                ["<C-n>"] = fb_actions.create,
                ["<C-r>"] = fb_actions.rename,
                ["<C-v>"] = fb_actions.copy,
                ["<C-x>"] = fb_actions.remove,
                ["<C-b>"] = fb_actions.move,
              },
            },
          },
        },
        pickers = {
          find_files = { find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*", "--no-require-git" } },
        },
      })
      require("telescope").load_extension("file_browser")
    end,
  },
}

----------------------------
---------------------------
-- # how Telescope file_browser handles ignore
-- respect_gitignore=false -> appends --no-ignore-vcs to find_command
-- no_ignore=true -> appends --no-ignore to the find_command
-- note, .ignore is still applied with the default configuration (passing no opts to file_browser)
---------------------------
-- # Telescope find_files
-- both hotkeys can be configured by editing the find_command with --no-ignore-vcs, or --no-ignore
-- rg params
-- --no-ignore-vcs -> do not respect gitignore in current git repo
-- --no-ignore -> do not respect any ignore files, .gitignore or .ignore

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
        "<leader>sg",
        function()
          require("telescope.builtin").live_grep({ additional_args = { "--no-ignore-parent" }, cwd = vim.loop.cwd() })
        end,
        -- function()
        -- require("telescope.builtin").live_grep({ additional_args = { "--no-ignore-vcs" }, cwd = vim.loop.cwd() })
        -- end,
        desc = "Grep ()",
      },
      -- to search witihin nautilus_trader that has been .ignored
      -- why vim.loop.cwd() -> sometimes I want to cd into a folder that is either .gitignored or .ignored and view results from this folder only
      {

        "<leader>/",
        function()
          require("telescope.builtin").live_grep({
            additional_args = { "--no-ignore", "--follow" },
            cwd = vim.loop.cwd(),
          })
        end,
        desc = "Grep ()",
      },
      {
        "<leader>sG",
        function()
          require("telescope.builtin").live_grep({
            additional_args = { "--no-ignore", "--follow" },
            cwd = vim.loop.cwd(),
          })
        end,
        desc = "Grep ()",
      },
      {
        "<leader>fb",
        function()
          require("telescope").extensions.file_browser.file_browser({
            path = vim.fn.expand("%:p:h"),
            select_buffer = true,
            respect_gitignore = false,
          })
        end,
        desc = "File Browser - Buffer (.gitignore .ignore)",
      },
      {
        "<leader>ff",
        function()
          require("telescope").extensions.file_browser.file_browser({
            respect_gitignore = true,
          })
        end,
        desc = "File Browser (.ignore)",
      },
      {
        "<leader>fF",
        function()
          require("telescope").extensions.file_browser.file_browser({
            no_ignore = true,
            cwd = vim.loop.cwd(),
          })
        end,
        desc = "File Browser ()",
      },

      {
        "<leader>fv",
        function()
          require("telescope").extensions.file_browser.file_browser({ cwd = vim.loop.os_homedir() .. "/dot" })
        end,
        desc = "File Browser - ~/dot (.ignore)",
      },
      {
        "<leader>fc",
        function()
          require("telescope").extensions.file_browser.file_browser({ cwd = vim.fn.stdpath("config") })
        end,
        desc = "Find Config File (.ignore)",
      },
      {
        "<leader>fg",
        function()
          -- ended up not using search_dirs and using .ignore file instead
          -- print("hostname", vim.loop.os_gethostname())
          -- local neoconf = require("neoconf.settings")
          -- local settings = require("neoconf").get(vim.loop.os_gethostname() .. ".search_dirs")
          -- print(vim.inspect(settings))
          -- why not use the LazyVim default that uses find_files / git_files in a single hotkey?
          -- because when working with monorepos, I need to search files that are not gitignored
          require("telescope.builtin").find_files()
        end,
        desc = "Find Files (.ignore)",
      },
    },
    config = function()
      local fb_actions = require("telescope").extensions.file_browser.actions
      require("telescope").setup({
        extensions = {
          file_browser = {
            depth = 1, -- start at depth 1
            auto_depth = true, -- when starting to type, show all depths
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
          find_files = { find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*", "--no-ignore-vcs" } },
        },
      })
      require("telescope").load_extension("file_browser")
      -- require("telescope").load_extension("ultisnips")
      -- vim.keymap.set({ "n", "i" }, "<C-l>", function()
      --   local snippet = "foo" .. (vim.api.nvim_get_mode().mode == "n" and " " or "")
      --   local after = vim.api.nvim_get_mode().mode == "n"
      --   vim.api.nvim_put({ snippet }, "", after, true)
      --   vim.fn["UltiSnips#ExpandSnippet"]()
      -- end)
    end,
  },
}

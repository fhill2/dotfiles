vim.cmd("set mouse=a")
vim.cmd("colorscheme tokyonight")
vim.cmd("packadd packer.nvim")
require("packer").startup(function(use)
-- use({
--     "kristijanhusak/orgmode.nvim",
--     config = function()
--       require("plugin.orgmode")
--     end,
--   })

-- use({
--     --forks .. "/telescope.nvim",
--     "nvim-telescope/telescope.nvim",
--     opt = false,
--     config = function()
--     require("plugin.telescope.init")
--     end,
--     --cmd = { "Telescope" },
--     --module = "telescope",
--     --keys = { "<leader><space>", "<leader>fz", "<leader>pp" },
--     -- wants = {
--     --   "plenary.nvim",
--     --   "popup.nvim",
--     --   "telescope-fzy-native.nvim",
--     --   "telescope-project.nvim",
--     --   "trouble.nvim",
--     --   "telescope-symbols.nvim",
--     --   "nvim-web-devicons",
--     --   --"telescope-zoxide.nvim",
--     --   "telescope-repo.nvim",
--     -- },
--     requires = {
--       "nvim-telescope/telescope-cheat.nvim",
--       "dhruvmanila/telescope-bookmarks.nvim",
--       "nvim-telescope/telescope-project.nvim",
--       "nvim-lua/popup.nvim",
--       "cljoly/telescope-repo.nvim",
--       "nvim-telescope/telescope-fzf-native.nvim",
--       "nvim-lua/plenary.nvim",
--       "nvim-telescope/telescope-symbols.nvim",
--       "nvim-telescope/telescope-fzy-native.nvim",
--       "fhill2/telescope-ultisnips.nvim",
--       --"jvgrootveld/telescope-zoxide",
--       "nvim-telescope/telescope-frecency.nvim",
--       "project.nvim",
--     },
--   })
--use("michaelb/sniprun")
  use({
    "nvim-neorg/neorg",
    -- config = function()
    --   require("plugin.neorg.init")
    -- end,
    opt = false,
    after = "nvim-treesitter",
    version = "0.0.11",
    requires = {
      "nvim-lua/plenary.nvim",
      "vhyrro/neorg-telescope",
    },
  })
  use("nvim-treesitter/nvim-treesitter")
end)


-- require'sniprun'.setup({
--   selected_interpreters = {},     --# use those instead of the default for the current filetype
--   repl_enable = { "Python3_original" },               --# enable REPL-like behavior for the given interpreters
--   repl_disable = {},              --# disable REPL-like behavior for the given interpreters
--   interpreter_options = {},       --# intepreter-specific options, consult docs / :SnipInfo <name>
--   display = {
--     "Classic",                    --# display results in the command-line  area
--     "VirtualTextOk",              --# display ok results as virtual text (multiline is shortened)
--   },

-- })

vim.cmd("packadd neorg")
local parser_configs = require('nvim-treesitter.parsers').get_parser_configs()

parser_configs.norg = {
  install_info = {
    url = "https://github.com/nvim-neorg/tree-sitter-norg",
    files = { "src/parser.c", "src/scanner.cc" },
    branch = "main"
  },
}

parser_configs.norg_meta = {
  install_info = {
    url = "https://github.com/nvim-neorg/tree-sitter-norg-meta",
    files = { "src/parser.c" },
    branch = "main"
  },
}

parser_configs.norg_table = {
  install_info = {
    url = "https://github.com/nvim-neorg/tree-sitter-norg-table",
    files = { "src/parser.c" },
    branch = "main"
  },
}

require("neorg").setup({
  -- Tell Neorg what modules to load
  load = {
    ["core.defaults"] = {}, -- Load all the default modules
    ["core.norg.concealer"] = {}, -- Allows for use of icons
    ["core.norg.dirman"] = { -- Manage your directories with Neorg
      config = {
        workspaces = {
          my_workspace = "~/neorg",
        },
      },
    },
    --["utilities.vlc"] = {},
    --["utilities.dateinserter"] = {},
    -- ["core.norg.completion"] = {
    --   config = {
    --     engine = "nvim-cmp", -- We current support nvim-compe and nvim-cmp only
    --   },
    -- },
    ["core.integrations.telescope"] = {}, -- Enable the telescope module
  },
  hook = function() 
  --   require"plugin.neorg.keybinds"
  -- This sets the leader for all Neorg keybinds. It is separate from the regular <Leader>,
  -- And allows you to shove every Neorg keybind under one "umbrella".
  local neorg_leader = "<Leader>p" -- You may also want to set this to <Leader>o for "organization"

    -- Require the user callbacks module, which allows us to tap into the core of Neorg
    local neorg_callbacks = require("neorg.callbacks")

  -- Listen for the enable_keybinds event, which signals a "ready" state meaning we can bind keys.
  -- This hook will be called several times, e.g. whenever the Neorg Mode changes or an event that
  -- needs to reevaluate all the bound keys is invoked
  neorg_callbacks.on_event("core.keybinds.events.enable_keybinds", function(_, keybinds)
    -- Map all the below keybinds only when the "norg" mode is active
    keybinds.map_event_to_mode("norg", {
      n = { -- Bind keys in normal mode

        -- Keys for managing TODO items and setting their states
        { "gtd", "core.norg.qol.todo_items.todo.task_done" },
        { "gtu", "core.norg.qol.todo_items.todo.task_undone" },
        { "gtp", "core.norg.qol.todo_items.todo.task_pending" },
        { "<C-Space>", "core.norg.qol.todo_items.todo.task_cycle" },
        --{ "mn", "utilities.vlc.save" },
        --   { "<C-s>", "core.integrations.telescope.find_linkable" },
        --{ "<C-LeftMouse>", "" }
      },
      i = { -- Bind in insert mode
        --   { "<C-l>", "core.integrations.telescope.insert_link" },
      },
    }, {
        silent = true,
        noremap = true,
      })
  end)
  end
})

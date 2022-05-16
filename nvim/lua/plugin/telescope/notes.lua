--local root = require("util.project_root").get_project_root
local Job = require("plenary.job")
local fs = require("util.fs")

local actions = require("telescope.actions")
local my_actions = require("plugin.telescope.actions")
local actions_set = require("telescope.actions.set")
local make_entry = require("telescope.make_entry")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local utils = require("telescope.utils")
local conf = require("telescope.config").values
local entry_display = require("telescope.pickers.entry_display")
local db_client = require("telescope._extensions.frecency.db_client")
local sorters = require("telescope.sorters")
local os_home = vim.loop.os_homedir()
local os_path_sep = utils.get_separator()
local Job = require("plenary.job")
local uv = vim.loop
local utils = require("telescope.utils")
local make_entry = require("telescope.make_entry")
local has_devicons, devicons = pcall(require, "nvim-web-devicons")
local previewers = require"telescope.previewers"
local notes = {}

local cwd = "/home/f1/dev/notes/DEV/linux"

function notes.dirs(opts)
local opts = opts or {}
require"telescope.builtin".find_files({
cwd = cwd,
find_command = { "fd", "--type", "d" },
attach_mappings = function(prompt_bufnr, map)
  map("i", "<C-n>", my_actions.create_note)

  actions_set.select:replace(function(_, type)
        my_actions.cd(prompt_bufnr)
      end)

 return true
end
})
end

function notes.files(opts)
local opts = opts or {}
require"telescope.builtin".find_files({
--previewer = previewers.vim_buffer_cat.new,
layout_strategy = "horizontal",
cwd = cwd,
find_command = { "fd", "--extension", "norg" },
})
end

function notes.search_tag(tag)
  -- returns every line of text within a note that is tagged as the input tag
  local args = { "--no-filename", "--color=never", "--no-heading", "--context=100000" }
  -- use --file-with-matches instead
end

function notes.tags(opts)
  local opts = opts or {}
  if not opts.cwd then opts.cwd = "~/neorg" end
  
end

return notes

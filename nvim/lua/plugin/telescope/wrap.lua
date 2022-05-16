-- [WIP]
-- extension wrapper
local telescope = require"telescope"
local actions = require'telescope.actions'
local actions_set = require'telescope.actions.set'
local sorters = require"telescope.sorters"
local config = require"telescope.config"
local my_actions = require"plugin.telescope.actions"
local find_frecency = require"plugin.telescope.find_frecency"
local wrap = {}


-- function wrap.repo(opts)
-- local opts = opts or {}
-- opts.attach_mappings = function(prompt_bufnr)
--       actions_set.select:replace(function(_, type)
--       my_actions.cd(prompt_bufnr)
--       end)
--       return true
--     end
-- opts.previewer = false

--   telescope.extensions.repo.list(opts)
-- end

function wrap.grep()

require"telescope.builtin".grep_string({
max_results=10000000,
search = "",
--sorter = sorters.get_generic_fuzzy_sorter,  -- fzf
})
end


function wrap.ff_cwd()
find_frecency.show({
 cwd = vim.fn.getcwd(),
 prompt_prefix = "ff " .. vim.fn.getcwd() .. " > ",
})
end

---------- NOTES ----------
local notes_cwd = "/home/f1/dev/notes/dev/dev-linux"
function wrap.notes_files()
  find_frecency.show({
    prompt_prefix = "notes_files > ",
    cwd = notes_cwd,
    sortby = "mtime",
  })
end

function wrap.notes_dirs(opts)
  local opts = opts or {}
  require"telescope.builtin".find_files({
    cwd = notes_cwd,
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

-- function notes.search_tag(tag)
--   -- returns every line of text within a note that is tagged as the input tag
--   local args = { "--no-filename", "--color=never", "--no-heading", "--context=100000" }
--   -- use --file-with-matches instead
-- end

-- function notes.tags(opts)
--   local opts = opts or {}
--   if not opts.cwd then opts.cwd = "~/neorg" end

-- end


















return wrap

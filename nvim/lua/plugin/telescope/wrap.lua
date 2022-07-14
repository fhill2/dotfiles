-- [WIP]
-- extension wrapper
local find_frecency = require "plugin.telescope.find_frecency"
-- local notes_cwd = "/home/f1/dev/notes"
local home = vim.loop.os_homedir()
local utils = require "plugin.telescope.util"
local fb_actions = require "telescope".extensions.file_browser.actions
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

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

-- function wrap.grep()
--
--   require "telescope.builtin".grep_string({
--     max_results = 10000000,
--     search = "",
--     --sorter = sorters.get_generic_fuzzy_sorter,  -- fzf
--   })
-- end

-- /home/f1/dev/bin/omni-awe.lua
-- /home/f1/dot/xplr/plugins/icons

local fb = function(opts)
  require "telescope".extensions.file_browser.file_browser(opts)
  -- local picker = action_state.get_current_picker(utils.find_prompt())
  -- picker.register_completion_callback(function()
  --   dump("MANUAL COMPLETION CALLBACK")

  -- end)
  -- vim.schedule(function()
  -- end)
end

-- function wrap.fb__dot_files()

-- end

-- so I can still use file_browser with default settings

local defaults = {
  depth = false,
  add_dirs = true,
  -- sorter = my_sorters.fb_sorter(),
  cwd_to_path = true,
  on_complete = {
    function(picker)
      dump("on complete called")
      dump(picker.prompt_bufnr)

      -- vim.defer_fn(function()
      -- dump("deferred")
      fb_actions.sort_by_date(picker.prompt_bufnr)
      -- end, 1500)
      -- picker.clear_completion_callbacks()
    end,
  }
}
local merge = function(t)
  return vim.tbl_deep_extend("force", defaults, t)
end

function wrap.fb()
  fb(defaults)
end

function wrap.fb_dot()
  fb(merge({
    path = home .. "/dot",
  }))
end

function wrap.fb_cwd()
  fb(merge({
    path = vim.fn.getcwd(),
  }))
end

function wrap.fb_dev()
  fb(merge({
    path = home .. "/dev"
  }))
end

function wrap.fb_home()
  fb(merge({
    path = home,
  }))
end

function wrap.fb_notes()
  fb(merge({
    path = home .. "/dev/notes/linux",
  }))
end

function wrap.ff_dirs_repos()
  wrap.ff_dirs({ show_repos = true })
end

function wrap.ff_files_repos()
  wrap.ff_files({ show_repos = true })
end

function wrap.ff_dirs(opts)
  -- dirs only
  local opts = opts or {}
  opts.dirs_only = true
  find_frecency.show(opts)
end

function wrap.ff_files(opts)
  local opts = opts or {}
  opts.mtime = false
  opts.show_dirs = false
  find_frecency.show(opts)
end

--
-- function wrap.ff_dirs_only_home()
--   wrap.ff_dirs_only({ cwd = vim.fn.expand("~") })
-- end
--
-- function wrap.ff_dirs_only_notes()
--   wrap.ff_dirs_only({ cwd = notes_cwd })
-- end
--

------------



-- function wrap.ff_files_dirs_home()
--   wrap.ff_files_dirs({ cwd = vim.fn.expand("~") })
-- end
--
-- function wrap.ff_files_dirs()
--   local opts = opts or {}
--   opts.show_dirs = true
--   opts.mtime = false
--   find_frecency.show(opts)
-- end
--
-- function wrap.ff_files_home()
--   wrap.ff_files({ cwd = vim.fn.expand("~") })
-- end
--
-- function wrap.ff_files_notes()
--   wrap.ff_files({ cwd = notes_cwd })
-- end
--


---------- NOTES ----------
-- function wrap.notes_files()
--   find_frecency.show({
--     prompt_prefix = "notes_files > ",
--     cwd = notes_cwd,
--     sortby = "mtime",
--   })
-- end
--
-- function wrap.notes_dirs(opts)
--   local opts = opts or {}
--   require "telescope.builtin".find_files({
--     cwd = notes_cwd,
--     find_command = { "fd", "--type", "d" },
--     attach_mappings = function(prompt_bufnr, map)
--       map("i", "<C-n>", my_actions.create_note)
--
--       actions_set.select:replace(function(_, type)
--         my_actions.cd(prompt_bufnr)
--       end)
--
--       return true
--     end
--   })
-- end

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

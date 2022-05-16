-- WIP
-- frecency + fd combined
-- TODO: rework after multiple finder sources is supported
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local utils = require("telescope.utils")
local conf = require("telescope.config").values
local entry_display = require("telescope.pickers.entry_display")
local db_client = require("telescope._extensions.frecency.db_client")
local sorters = require("telescope.sorters")
--local os_home = vim.loop.os_homedir()
local os_path_sep = utils.get_separator()
--local Job = require("plenary.job")
--local uv = vim.loop
--local utils = require "telescope.utils"
--local make_entry = require "telescope.make_entry"
--local actions = require"telescope.actions.init"
local action_set = require 'telescope.actions.set'
local action_state = require 'telescope.actions.state'
local my_actions = require "plugin.telescope.actions"


local show = function(opts)
  local opts = opts or {}
  -- CHANGE
  assert(opts.cwd, "forgot to pass in a cwd")
  -- local find_command = {
  --   command = "fd",
  --   args = { "-HI", "--type", "f", "-L", "-a" },
  -- } -- -a to output absolute paths to be compared with frecency db

  --opts.find_command = function() return { command = "fd", arg = {"-HI", "--type", "f", "-L", "-a" }} end
  local find_command = opts.find_command or { "fd", "-HI", "--type", "f", "-L", "-a" }
  if not vim.tbl_contains(find_command, "-a") then assert("fd absolute file paths needed") end

  opts.cwd = vim.fn.expand(opts.cwd)
  --TODO: set exclude per cwd, create extension and set in global config

  -- if opts.cwd == f.cl then
  --   local ignore_paths = { "/dev/dot/old", "result", ".git", "node_modules" }
  --   for _, ignore in ipairs(ignore_paths) do
  --     table.insert(find_command, "-E")
  --     table.insert(find_command, ignore)
  --   end
  -- end


  -- 1st arg false doesnt add plenary sync scandir
  -- 2nd arg left out retrieves all entries from db instead of a filtered workspace
  local scores = db_client.get_file_scores(false, opts.cwd)

  local scores_map = {}
  for _, v in ipairs(scores) do
    scores_map[v.filename] = v.score
  end


  local get_mtime = function(fp)
    -- absolute path needed
    local mtime = vim.loop.fs_lstat(fp).mtime.sec
    return tonumber(os.date("%Y%m%d.%H%M%S", mtime))
  end

  --------- ACTIONS --------
  local switch_sorter = function(prompt_bufnr)
    local picker = action_state.get_current_picker(prompt_bufnr)
    local sorter_state = picker.sorter.state
    sorter_state.sortby = sorter_state.sortby == "mtime" and "frecency" or "mtime"
    picker:refresh()
  end


  --------- ENTRY MAKER --------
  local displayer = entry_display.create({
    separator = "",
    hl_chars = { [os_path_sep] = "TelescopePathSeparator" },
    items = {
      { width = 17 },
      { width = 6, left_justify = true },
      { width = 2 },
      { remaining = true },
    },
  })

  local make_display = function(entry)
    local has_devicons, devicons = pcall(require, "nvim-web-devicons")
    local display_items = { { entry.mtime, "TelescopeMTime" }, { entry.rank, "TelescopeFrecencyScores" } }
    local icon, icon_highlight = devicons.get_icon(entry.value, string.match(entry.value, "%a+$"), { default = true })
    table.insert(display_items, { icon, icon_highlight })
    table.insert(display_items, { entry.value, "TelescopeFindFrecency" })
    return displayer(display_items)
  end

  opts.entry_maker = function(fp)
    local entry = {
      value = fp,
      ordinal = fp,
    }
    entry.mtime = get_mtime(fp)

    if scores_map[fp] then
      entry.rank = scores_map[fp]
    else
      entry.rank = 0
    end
    entry.display = make_display
    return entry

  end

  --------- SORTERS --------
  local my_telescope_sorter = function(opts)
    opts = opts or {}
    opts.ngram_len = 2
    opts.sortby = opts.sortby or "mtime"

    local fuzzy_sorter = sorters.get_generic_fuzzy_sorter(opts)

    return sorters.Sorter:new({
      init = function(self)
        self.state.sortby = opts.sortby
      end,
      scoring_function = function(self, prompt, line, entry, cb_add, cb_filter)
        -- lower returned score is better - puts the result closer to the top/default selection
        local base_score = fuzzy_sorter:scoring_function(prompt, line, cb_add, cb_filter)

        if base_score == -1 then return -1 end

        if self.state.sortby == "frecency" then
          -- if no frecency rank, then return generic fuzzy sorter score
          -- as fuzzy scores can get close to 0, make sure the maximum / highest scores stays above 1
          if entry.rank == 0 then return base_score + 1 end
          -- lowest frecency rank possible is 1,
          -- +1 to make sure math.pow() outputs ~0.5 as the max value or lowest frecency score
          -- higher frecency scores will output lower math.pow() scores
          if entry.rank > 0 then return math.pow(entry.rank + 1, -1) end
        end


        if self.state.sortby == "mtime" then
          return math.pow(entry.mtime, -1)
        end

      end,
      highlighter = fuzzy_sorter.highlighter
    })
  end

  --------- PICKERS --------
  pickers.new(opts, {
    prompt_title = "Find Frecency",
    attach_mappings = function(prompt_bufnr, map)
    --   action_set.select:replace(function(_, type)
    --     local entry = action_state.get_selected_entry()
    --     my_actions.edit(prompt_bufnr, entry.value)
    --   end)
    --   map("i", "<C-f>", switch_sorter)
       return true
     end,

    finder = finders.new_oneshot_job(find_command, opts),
    previewer = conf.file_previewer(opts),

    sorter = my_telescope_sorter(),


  }):find()

end
return {
  show = show,
}

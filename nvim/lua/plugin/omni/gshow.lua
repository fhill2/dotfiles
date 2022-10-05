local M = {}

--local actions = require"telescope.actions"
local my_actions = require("plugin.telescope.actions")
local actions_state = require("telescope.actions.state")
local actions_set = require("telescope.actions.set")
local entry_display = require("telescope.pickers.entry_display")

function M.gshow(opts)
	local finders = require("telescope.finders")
	local pickers = require("telescope.pickers")
	local conf = require("telescope.config").values
	local sorters = require("telescope.sorters")

	local opts = opts or {}
	opts.results = require("plugin.omni.gentries")
	opts.global = true

	opts.attach_mappings = function(prompt_bufnr)
		actions_set.select:replace(function(_, type)
			my_actions.dropdown_exit(prompt_bufnr)
		end)
		return true
	end

	local displayer = entry_display.create({
		separator = "",
		--hl_chars = { [os_path_sep] = "TelescopePathSeparator" },
		items = {
			{ width = 50 },
			{ remaining = true },
		},
	})

	local make_display = function(entry)
		--local display_items = { { entry.score, "TelescopeFrecencyScores" } }
		--local icon, icon_highlight = devicons.get_icon(entry.filename, string.match(entry.filename, "%a+$"), { default = true })
		--table.insert(display_items, { icon, icon_highlight })
		--table.insert(display_items, { entry.filename, "TelescopeFindFrecency"})
		return displayer({ entry.title, entry.value })
	end

	local entry_maker = function(entry)
		return {
			title = entry.title,
			display = make_display,
			ordinal = entry.title .. entry.cmd,
			value = entry.cmd,
		}
	end

	pickers
		.new(opts, {
			prompt_title = "Omnimenu",

			finder = finders.new_table({
				results = opts.results,
				entry_maker = entry_maker,
			}),

			previewer = conf.file_previewer(opts),
			sorter = sorters.get_substr_matcher(opts),
			attach_mappings = opts.attach_mappings,
		})
		:find()
end

return M

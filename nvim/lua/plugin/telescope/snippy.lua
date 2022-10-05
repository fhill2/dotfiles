local entry_display = require("telescope.pickers.entry_display")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local previewers = require("telescope.previewers")
local sorters = require("telescope.sorters")
local treesitter = require("telescope.previewers.utils")
local snippy = require("snippy")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local M = {}
function M.show(opts)
	local snippets = snippy.get_completion_items()
	local snippets_ft = vim.bo.filetype

	local opts = opts or {}
	local snippets_formatted = {}
	for _, snippet in pairs(snippets) do
		local snip = snippet.user_data.snippy.snippet
		table.insert(snippets_formatted, {
			snippet = snippet,
			prefix = snip.prefix,
			description = snip.description,
			body = snip.body,
		})
	end

	local preview_command = function(entry, bufnr)
		vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, entry.snippet.body)
		treesitter.highlighter(bufnr, snippets_ft)
	end

	local displayer = entry_display.create({
		separator = "| ",
		items = { { width = 7 }, { width = 27 }, { remaining = true } },
	})

	local make_display = function(entry)
		return displayer({ entry.snippet.prefix, entry.snippet.description, entry.body_str })
	end

	local entry_maker = function(entry)
		return {
			snippet = entry,
			body_str = table.concat(entry.body, " "),
			display = make_display,
			ordinal = entry.prefix,
			preview_command = preview_command,
		}
	end
	pickers
		.new(opts, {
			prompt_title = "Snippy",
			finder = finders.new_table({
				results = snippets_formatted,
				entry_maker = entry_maker,
			}),
			previewer = previewers.display_content.new(opts),
			sorter = sorters.get_generic_fuzzy_sorter(),
			attach_mappings = function()
				actions.select_default:replace(function(prompt_bufnr)
					local entry = action_state.get_selected_entry()
					actions.close(prompt_bufnr)
					snippy.expand_snippet(entry.snippet.snippet.user_data.snippy.snippet)
				end)
				return true
			end,
		})
		:find()
end

return M

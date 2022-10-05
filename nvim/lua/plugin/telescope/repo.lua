local root = require("util.project_root").get_project_root
local Job = require("plenary.job")
local fs = require("util.fs")

local actions = require("telescope.actions")
local my_actions = require("plugin.telescope.actions")
local actions_set = require("telescope.actions.set")
local make_entry = require("telescope.make_entry")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local pickers = require("telescope.pickers")

local M = {}

function M.show(opts)
	local opts = opts or {}

	local results = fs.scandir(f.cl, {
		on_insert = function(fp, type)
			-- leave out files, and file symlinks
			if type == "file" or fp:match("%.") then
				return false
			end
			local root = root(fp)
			return not root
		end,
	})

	local args = { "-H", "--type", "d", "--case-sensitive", "-a", "-x", "echo", [[{//}]], ";", [[^\.git$]] }
	Job:new({
		command = "fd",
		args = args,
		cwd = vim.env.HOME,
		on_stdout = function(err, line)
			table.insert(results, line)
		end,
	}):start()

	pickers
		.new(opts, {
			prompt_title = "cl Git repositories",
			finder = finders.new_table({
				results = results,
				entry_maker = make_entry.gen_from_file(opts),
			}),
			on_input_filter_cb = function(query_text)
				local new_finder = finders.new_table({
					results = results,
					entry_maker = make_entry.gen_from_file(opts),
				})

				return { prompt = query_text, updated_finder = new_finder }
			end,
			attach_mappings = function(prompt_bufnr)
				actions_set.select:replace(function(_, type)
					my_actions.cd_value(prompt_bufnr)
				end)
				return true
			end,

			sorter = conf.file_sorter(opts),
		})
		:find()
end

return M

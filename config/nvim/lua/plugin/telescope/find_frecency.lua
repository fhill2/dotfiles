-- WIP
-- frecency + fd combined
-- TODO: rework after multiple finder sources is supported
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local utils = require("telescope.utils")
local conf = require("telescope.config").values
local entry_display = require("telescope.pickers.entry_display")
local db_client = require("telescope._extensions.frecency.db_client")
local my_sorters = require("plugin.telescope.sorters")
local home = vim.loop.os_homedir()
--local os_home = vim.loop.os_homedir()
local os_path_sep = utils.get_separator()
--local Job = require("plenary.job")
--local uv = vim.loop
--local utils = require "telescope.utils"
--local make_entry = require "telescope.make_entry"
--local actions = require"telescope.actions.init"
local action_set = require("telescope.actions.set")
local action_state = require("telescope.actions.state")
local my_actions = require("plugin.telescope.actions")
local actions = require("telescope.actions")

local show = function(opts)
	local opts = opts or {}
	opts.mtime = true
	opts.dirs_and_files = not opts.dirs_only and opts.show_dirs

	-- make sure nothing is nil
	opts.cwd = opts.cwd or vim.fn.getcwd()

	opts.sort_keys = { "rank", "fuzzy", "fuzzy+rank" }
	opts.sort_keys = opts.mtime and table.insert(opts.sort_keys, 2, "date") or opts.sort_keys

	-- opts.sort_keys_map = {
	--   rank = "date",
	--   date = "fuzzy",
	--   fuzzy = "rank"
	opts.sortby = opts.sortby or "fuzzy+rank" -- rank or date

	if opts.dirs_only then
		opts.prompt_prefix = "dirs [" .. opts.sortby .. "] > "
	elseif opts.dirs_and_files then
		opts.prompt_prefix = "dirs files [" .. opts.sortby .. "] > "
	else
		opts.prompt_prefix = "files [" .. opts.sortby .. "] > "
	end

	local title = opts.show_repos and "repos" or opts.cwd
	opts.prompt_title = "ff " .. title

	opts.find_command = opts.find_command or { "fd" }

	local multi_insert = function(t, i)
		for _, v in ipairs(i) do
			table.insert(t, v)
		end
	end

	opts.repo_paths = {
		{ home .. "/.local/share/nvim/site/pack/packer/start", "packer/start - " },
		{ home .. "/.local/share/nvim/site/pack/packer/opt", "packer/opt - " },
		{ home .. "/git", "git - " },
		{ home .. "/repos", "repos - " },
	}

	if opts.show_repos then
		table.insert(opts.find_command, ".")
		for _, repo_path in ipairs(opts.repo_paths) do
			table.insert(opts.find_command, repo_path[1])
		end

		opts.path_display = function(opts, path)
			for _, repo_path in ipairs(opts.repo_paths) do
				if path:match(repo_path[1]) then
					return path:gsub(repo_path[1] .. "/", repo_path[2])
				end
			end
			return path
		end
	end

	multi_insert(opts.find_command, { "--hidden", "--no-ignore-vcs", "-a" })
	-- --follow - traverses into symlink dirs

	if not opts.dirs_only and not opts.show_dirs then
		table.insert(opts.find_command, "--type")
		table.insert(opts.find_command, "f")
	end

	if opts.dirs_only then
		table.insert(opts.find_command, "--type")
		table.insert(opts.find_command, "d")
	end

	--TODO: set exclude per cwd, create extension and set in global config

	--for _, ignore in ipairs({".git", ".cache", ".npm", ".venv", ".pyenv", ".vscode", ".vscode-insiders", ".cargo", ".rustup", "/target/", "nerd-fonts", "/seagate/", "/Trash/"}) do
	--table.insert(opts.find_command, "-E")
	--table.insert(opts.find_command, ignore)
	--end
	-- if not opts.cwd:match("") then
	-- --   local ignore_paths = { "/dev/dot/old", "result", ".git", "node_modules" }
	-- --   for _, ignore in ipairs(ignore_paths) do
	-- --     table.insert(find_command, "-E")
	-- --     table.insert(find_command, ignore)
	-- end

	-- 1st arg false doesnt add plenary sync scandir
	-- 2nd arg left out retrieves all entries from db instead of a filtered workspace
	if not opts.dirs_only then
		local frecency_scores = db_client.get_file_scores(false, opts.cwd)

		frecency_scores_map = {}
		for _, v in ipairs(frecency_scores) do
			frecency_scores_map[v.filename] = v.score
		end
	end

	if opts.dirs_only or opts.dirs_and_files then
		local zoxide_scores = utils.get_os_command_output({ "zoxide", "query", "-ls" })
		zoxide_scores_map = {}
		for _, item in ipairs(zoxide_scores) do
			local item = item:match("^%s*(.-)%s*$")
			local items = vim.split(item, " ")
			zoxide_scores_map[items[2]] = tonumber(items[1])
		end
	end

	local format_date = function(mtime)
		if os.date("%Y") ~= os.date("%Y", mtime) then
			return os.date("%b %d  %Y", mtime)
		end
		return os.date("%b %d %H:%M", mtime)
	end

	--------- ACTIONS --------
	local switch_sorter = function(prompt_bufnr)
		picker = action_state.get_current_picker(prompt_bufnr)
		-- toggle sortby 2 or 3 ways depending on opts.mtime
		for i, v in ipairs(opts.sort_keys) do
			if picker.sorter.sortby == v then
				picker.sorter.sortby = i ~= #opts.sort_keys and opts.sort_keys[i + 1] or opts.sort_keys[1]
				break
			end
		end
		local prompt = picker:_get_prompt()
		local rep = "[" .. picker.sorter.sortby .. "]"
		local match = picker.prompt_prefix:gsub("%[(.*)%]", rep)
		picker:change_prompt_prefix(match, "TelescopePromptPrefix")
		picker:set_prompt(prompt)
		picker:refresh()
	end

	local ff_default_replace = function(prompt_bufnr)
		local entry = action_state.get_selected_entry(prompt_bufnr)

		if vim.loop.fs_lstat(entry.fp).type == "directory" then
			os.execute("zoxide add " .. entry.fp)
			vim.api.nvim_set_current_dir(entry.fp)
			print("cd = " .. entry.fp)
			my_actions.close_or_exit(prompt_bufnr)
		else
			actions.file_edit(prompt_bufnr) -- closes too
		end
	end
	--------- ENTRY MAKER --------

	function get_entry_maker(opts)
		local items = {}
		--table.insert(items, { width = 17 })
		if opts.mtime then
			table.insert(items, { width = 17 })
		end
		table.insert(items, { width = 6, left_justify = true }) -- frecency
		table.insert(items, { width = 2 }) -- icons
		table.insert(items, { remaining = true })

		local displayer = entry_display.create({
			separator = "",
			hl_chars = { [os_path_sep] = "TelescopePathSeparator" },
			items = items,
		})

		local make_display = function(entry)
			local devicons = require("nvim-web-devicons")

			if opts.dirs_only or entry.is_dir then
				icon, icon_highlight = "", "Default"
			else
				icon, icon_highlight =
					devicons.get_icon(entry.value, string.match(entry.value, "%a+$"), { default = true })
				if icon == "" then
					local ext = entry.value:match("%.(.*)$")
					if ext == "norg" or ext == "neorg" then
						icon, icon_highlight = [[]], "DevIconEex"
					end
				end
			end

			local display_items = {}
			--table.insert(display_items, { entry.score, "TelescopeScore" })
			if opts.mtime then
				table.insert(display_items, { entry.date, hl = "TelescopePreviewDate" })
			end
			table.insert(display_items, { entry.rank, "TelescopeFrecencyScores" })
			table.insert(display_items, { icon, icon_highlight })
			table.insert(display_items, { entry.value, "TelescopeFindFrecency" })
			return displayer(display_items)
		end

		return function(fp)
			local entry = {}
			-- TODO: entry.value relative path in display format. entry.value = abs path
			-- or try telescope paths

			if opts.mtime or opts.dirs_and_files then
				stat = vim.loop.fs_lstat(fp)
			end

			if opts.dirs_and_files then
				entry.is_dir = stat.type == "directory"
			end
			--entry.value = "." .. fp:gsub(opts.cwd, "")
			entry.value = utils.transform_path(opts, fp)
			entry.ordinal = entry.value

			if opts.dirs_only then
				entry.rank = zoxide_scores_map[fp] or 0
			else
				if opts.dirs_and_files then
					entry.rank = entry.is_dir and zoxide_scores_map[fp] or frecency_scores_map[fp] or 0
				else
					entry.rank = frecency_scores_map[fp] or 0
				end
			end

			if opts.mtime then
				entry.mtime = stat.mtime.sec
				entry.date = format_date(entry.mtime)
			end

			entry.fp = fp
			--entry.score = 0
			entry.display = make_display
			return entry
		end
	end

	opts.entry_maker = get_entry_maker(opts)

	------- PICKERS --------
	local state = {}
	state.picker = pickers.new(opts, {
		prompt_title = opts.prompt_title,
		results_title = "c-f:switch_sorter - [" .. opts.sortby .. "]",
		on_input_filter_cb = function(query_text) end,
		attach_mappings = function(prompt_bufnr, map)
			action_set.select:replace(function()
				ff_default_replace(prompt_bufnr)
			end)
			map("i", "<C-f>", switch_sorter)
			return true
		end,

		finder = finders.new_oneshot_job(opts.find_command, opts),
		previewer = conf.file_previewer(opts),

		sorter = my_sorters.frecency_sorter(opts),
		--sorter = require("telescope.sorters").get_generic_fuzzy_sorter,
		--sorter = sorters.get_fuzzy_file(),
	})
	state.picker:find()
end
return {
	show = show,
}

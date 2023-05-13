local action_utils = require("telescope.actions.utils")
local actions = require("telescope.actions")
local uv = vim.loop
local my_utils = require("plugin.telescope.util")
local state = require("telescope.state")
local pickers = require("telescope.pickers")
local action_state = require("telescope.actions.state")
local fb_utils = require("telescope._extensions.file_browser.utils")

local function fp()
	local entry = entry()
	return ("%s/%s"):format(entry.cwd, entry[1])
end

local function dropdown_out(data)
	require("util.fs").write(vim.loop.os_homedir() .. "/tmp/cli", data)
end

local A = {}
function A.close_or_exit(prompt_bufnr, data)
	-- if dropdown, exit nvim
	if CLI then
		-- if prompt_bufnr then actions.close(prompt_bufnr) end
		dropdown_out(data)
		vim.cmd("silent qa!")
	else
		actions.close(prompt_bufnr)
	end
end

function A.move_previewer_window(prompt_bufnr)
	local picker = action_state.get_current_picker(prompt_bufnr)
end

function A.dropdown_exit(prompt_bufnr)
	if not dropdown_profile then
		vim.api.nvim_err_writeln("not in dropdown profile, doing nothing")
		return
	end
	local entry = entry()
	close_or_exit(prompt_bufnr, entry.value)
end

function A.find_files(prompt_bufnr)
	require("telescope.builtin").find_files({ cwd = fp() })
end

function A.live_grep(prompt_bufnr)
	require("telescope.builtin").live_grep({ cwd = fp() })
end

-- function A.create_note(prompt_bufnr)
--   close_or_exit(prompt_bufnr)
--   require("util.fs").create_file_prompt({
--     dest = fp(),
--     ext = "norg",
--   })
-- end

function A.resize(prompt_bufnr)
	local picker = action_state.get_current_picker(prompt_bufnr)
	-- built in layout strats:
	-- horizontal, center, cursor, vertical, flex, bottom_pane
	local height = picker.layout_config.horizontal.height
	picker.layout_config.horizontal.height = height == 0.4 and 0.99 or 0.4
	picker:full_layout_update()
end

function A.close_from_editor()
	pickers.on_close_prompt(my_utils.find_prompt())
end

function A.toggle_focus_picker()
	local prompt_bufnr = my_utils.find_prompt()
	if not prompt_bufnr then
		return
	end

	local picker_focused = vim.api.nvim_get_current_buf() == prompt_bufnr
	if picker_focused then
		vim.api.nvim_set_current_win(_G.current_editor_win)
	else
		local picker = action_state.get_current_picker(prompt_bufnr)
		vim.api.nvim_set_current_win(action_state.get_current_picker(prompt_bufnr).prompt_win)
	end
end

local last_win
function A.toggle_focus_previewer()
	local picker = my_utils.find_picker()
	if not picker then
		return
	end

	local cwin = vim.api.nvim_get_current_win()
	local previewer_focused = cwin == picker.preview_win
	if previewer_focused then
		return last_win and vim.api.nvim_set_current_win(_G.current_editor_win)
			or vim.api.nvim_set_current_win(last_win)
	else
		last_win = cwin
		vim.api.nvim_set_current_win(picker.preview_win)
	end
end

-- function A.which_key(prompt_bufnr, opts)
--   -- fix for standard preview - which key errors
--   local picker = action_state.get_current_picker(prompt_bufnr)
--   local old_preview = picker.preview_win
--   picker.preview_win = nil
--   actions.which_key(prompt_bufnr, opts)
--   picker.preview_win = old_preview
-- end

function A.fb_change_depth(prompt_bufnr)
	local picker = action_state.get_current_picker(prompt_bufnr)
	local finder = picker.finder
	local opts = picker.initial_opts
	if not opts.depth then
		opts.depth = 1
	else
		opts.depth = false
	end
	actions.close(prompt_bufnr)
	require("telescope").extensions.file_browser.file_browser(opts)
end

function A.close_or_resume()
	local picker = my_utils.find_picker()
	-- if vim.tbl_contains({picker.prompt_win, picker.preview_win}, vim.api.nvim_get_current_win()) then
	-- print("telescope selection")
	-- end
	if picker == nil then
		vim.cmd("Telescope resume")
	else
		actions.close(picker.prompt_bufnr)
	end
end

------------------------------- BUKU EDITING BOOKMARKS BELOW HERE ----------------
local finders = require("telescope.finders")
local entry_display = require("telescope.pickers.entry_display")

local refresh_bookmarks = function(picker)
	local state = {
		os_name = vim.loop.os_uname().sysname,
		os_homedir = vim.loop.os_homedir(),
	}
	local config = { buku_include_tags = true }
	local results = require("telescope._extensions.bookmarks.buku").collect_bookmarks(state, config)

	local displayer = entry_display.create({
		separator = " ",
		items = config.buku_include_tags and {
			{ width = 0.3 },
			{ width = 0.2 },
			{ remaining = true },
		} or {
			{ width = 0.5 },
			{ remaining = true },
		},
	})

	local function make_display(entry)
		local display_columns = {
			entry.name,
			{ entry.value, "Comment" },
		}
		if config.buku_include_tags then
			table.insert(display_columns, 2, { entry.tags, "Special" })
		end
		return displayer(display_columns)
	end

	local finder = finders.new_table({
		results = results,
		entry_maker = function(entry)
			local name = (config.full_path and entry.path or entry.name) or ""
			return {
				display = make_display,
				name = name,
				value = entry.url,
				tags = entry.tags,
				ordinal = name .. " " .. (entry.tags or "") .. " " .. entry.url,
			}
		end,
	})
	picker:refresh(finder)
end

local get_selected_files = function(picker)
	local selections = picker:get_multi_selection()
	return vim.tbl_isempty(selections) and { action_state.get_selected_entry() } or selections
end

local add_completion_callback = function(picker, cb)
	-- dont reset position  when reloading
	picker._completion_callbacks = vim.F.if_nil(picker._completion_callbacks, {})
	table.insert(picker._completion_callbacks, function()
		cb(picker)
		table.remove(picker._completion_callbacks)
	end)
end

-- support multiselection
-- always puts first selected file as a placeholder into vim.ui.input
-- overwrites all selected bookmarks with the user input for the chosen field
local edit_bookmark_field = function(prompt_bufnr, entry_key, db_col)
	local picker = action_state.get_current_picker(prompt_bufnr)
	selection = get_selected_files(picker)
	local selected_row = picker:get_selection_row()
	local db = require("sqlite").new("/home/f1/.local/share/buku/bookmarks.db"):open()

	local input_opts = {
		default = selection[1][entry_key],
		prompt = "Enter " .. entry_key .. ":",
	}

	vim.ui.input(input_opts, function(input)
		local input = entry_key == "tags" and (",%s,"):format(input) or input
		for _, selected in ipairs(selection) do
			db:update("bookmarks", {
				values = { [db_col] = input },
				where = { id = selected.index },
			})
		end
		db:close()

		add_completion_callback(picker, function(picker)
			picker:set_selection(selected_row)
		end)

		refresh_bookmarks(picker)
	end)
end

function A.edit_bookmark_name(prompt_bufnr)
	edit_bookmark_field(prompt_bufnr, "name", "metadata")
end

function A.edit_bookmark_tags(prompt_bufnr)
	edit_bookmark_field(prompt_bufnr, "tags", "tags")
end

function A.edit_bookmark_url(prompt_bufnr)
	edit_bookmark_field(prompt_bufnr, "value", "URL")
end

_G.bookmarks_preview = false

function A.toggle_preview()
	-- _G.bookmarks_preview = not _G.bookmarks_preview and true or false
	if _G.bookmarks_preview then
		_G.bookmarks_preview = false
		os.execute("notify-send 'bookmarks preview off'")
	else
		_G.bookmarks_preview = true
		os.execute("notify-send 'bookmarks preview on'")
	end
end

local preview = function(prompt_bufnr, dir)
	actions["move_selection_" .. dir](prompt_bufnr)
	local entry = action_state.get_selected_entry()
	if _G.bookmarks_preview then
		-- os.execute("notify-send " .. entry.value)
		os.execute(([[echo '%s' > /home/f1/tmp/native.fifo]]):format(entry.value))
	end
end

function A.preview_previous(prompt_bufnr)
	preview(prompt_bufnr, "previous")
end

function A.preview_next(prompt_bufnr)
	preview(prompt_bufnr, "next")
end

function A.copy_bookmark_to_clipboard()
	local entry = action_state.get_selected_entry()
	os.execute(([[echo '%s' | wl-copy >> /dev/null]]):format(entry.value))
end

-- TODO: support through sqlite and multiselect
function A.delete_bookmark(prompt_bufnr)
	local entry = action_state.get_selected_entry()
	local picker = action_state.get_current_picker(prompt_bufnr)
	local selected_row = picker:get_selection_row()

	add_completion_callback(picker, function(picker)
		picker:set_selection(selected_row + 1)
	end)

	-- actions.move_selection_next(prompt_bufnr)
	os.execute(([[/usr/bin/buku --delete %s --tacit >> /dev/null]]):format(entry.index))
	refresh_bookmarks(action_state.get_current_picker(prompt_bufnr))
end

-- function A.get_row(prompt_bufnr)
--   local picker = action_state.get_current_picker(prompt_bufnr)
--   dump(picker:get_selection_row())
-- end

return A

----
-- local WriteQueue = require("fzf.utils").WriteQueue
-- local output_pipe = vim.loop.new_pipe(false)
--    local fd = uv.fs_open("/home/f1/tmp/native.fifo", "w", -1)
--    output_pipe:open(fd)
--    local write_queue = WriteQueue:new(output_pipe)
--    write_queue:enqueue("https://google.com")
-- self:handle_contents()

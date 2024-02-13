local action_state = require("telescope.actions.state")
local state = require("telescope.state")

local utils = {}

utils.get_editor_win_info = function()
	local windows = {}
	for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		if vim.api.nvim_win_get_config(win).relative == "" then
			-- win_config.relative == "" - only non floating windows
			local pos = vim.api.nvim_win_get_position(win)
			table.insert(windows, {
				winnr = win,
				y = pos[1],
				x = pos[2],
				w = vim.api.nvim_win_get_width(win),
				h = vim.api.nvim_win_get_height(win),
			})
		end
	end
	table.sort(windows, function(a, b)
		if a.x ~= b.x then
			return a.x < b.x
		end
		return a.y < b.y
	end)
	return windows
end

utils.get_editor_wins = function()
	local wins = {}
	for _, win in ipairs(utils.get_editor_win_info()) do
		table.insert(wins, win.winnr)
	end
	return wins
end

utils.get_editor_wins_no_previewer = function()
	local picker = utils.find_picker()
	local editor_wins = utils.get_editor_wins()
	if not picker then
		return editor_wins
	end
	local wins = {}
	for _, win in ipairs(editor_wins) do
		if picker.preview_win ~= win then
			table.insert(wins, win)
		end
	end
	return wins
end

utils.find_prompt = function()
	return vim.tbl_filter(function(b)
		return vim.bo[b].filetype == "TelescopePrompt"
	end, vim.api.nvim_list_bufs())[1]
end

utils.find_picker = function()
	return action_state.get_current_picker(utils.find_prompt())
end

utils.merge_status = function(t)
	local picker = utils.find_picker()
	local status = state.get_status(picker.prompt_bufnr)
	state.set_status(picker.prompt_bufnr, vim.tbl_deep_extend("force", status, t))
end

return utils

-- for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
--   local bufnr = vim.api.nvim_win_get_buf(win)
-- if vim.api.nvim_buf_get_option(bufnr, "filetype") == "TelescopePrompt" then
-- --   return action_state.get_current_picker(bufnr)
-- end
-- end

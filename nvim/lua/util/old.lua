-- local parser = require("util.old.parser")
-- local nui = require("plugin.nui.popup")
local uv = vim.loop
local Path = require("plenary.path")
local filetype = require("plenary.filetype")
local os_sep = Path.path.sep
local home = vim.loop.os_homedir()

local M = {}

-- function M.show(old_path)
--   --local cfp = vim.fn.expand("%:p")
--   --local old_path = M.parse(cfp)
--   --show_gui(old_path)
--   nui.popup({ name = "old", fp = old_path })
-- end

M.get_old_path = function()
	local cfp = Path:new(vim.fn.resolve(vim.fn.expand("%:p")))
	local old_path = Path:new(table.concat({ home, "dev", "old", Path:new(cfp.filename):make_relative(home) }, os_sep))
	return old_path, cfp
end

M.test = function()
	local old_path, cfp = M.send({ dry = true })
	vim.notify({ ("cfp: %s"):format(cfp.filename), ("old_path: %s"):format(old_path.filename) }, "info")
end

M.send_whole = function()
	M.send({ whole = true })
end

M.open_window = function()
	local old_path, cfp = M.get_old_path()
	dump(old_path, cfp)
	if not vim.loop.fs_stat(old_path.filename) then
		vim.notify({ ("old_path does not exist: %s"):format(old_path) }, "info")
		return
	end
	vim.cmd("sp " .. old_path)
end

local notify_old_contents = function(old_path)
	old_path:_read_async(function(data)
		vim.notify(data, "info", {
			title = old_path:make_relative(home),
			on_open = function(win)
				local buf = vim.api.nvim_win_get_buf(win)
				vim.api.nvim_buf_set_option(buf, "filetype", filetype.detect(old_path.filename))
			end,
		})
	end)
end

local send_whole_file = function(cfp, old_path)
	if uv.fs_stat(old_path.filename) then
		local data = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, true), "\n")
		old_path:write("\n\n" .. data .. "\n", "a")
		os.execute("trash " .. cfp.filename)
		notify_old_contents(old_path)
	else
		vim.notify({ ("Moving current file to: %s"):format(old_path.filename) })

		old_path:parent():mkdir({ parents = true })

		uv.fs_rename(cfp.filename, old_path.filename)
	end
	vim.cmd("Bdelete! " .. vim.api.nvim_get_current_buf())
end

local send_partial_file = function(old_path)
	old_path:parent():mkdir({ parents = true })

	local data = table.concat(f.get_visual({ lines = true }), "\n")
	old_path:write("\n\n" .. data .. "\n", "a")
	local range = f.get_visual({ range = true, lines = true })
	vim.api.nvim_buf_set_lines(vim.api.nvim_get_current_buf(), range.start_row - 1, range.end_row, false, {})
	notify_old_contents(old_path)
end

M.send = vim.schedule_wrap(function(opts)
	opts = opts or {}
	old_path, cfp = M.get_old_path()

	if opts.dry then
		return cfp.filename, old_path.filename
	end

	if opts.whole then
		send_whole_file(cfp, old_path)
	else
		send_partial_file(old_path)
	end
end)

return M

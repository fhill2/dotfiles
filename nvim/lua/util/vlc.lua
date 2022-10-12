local M = {}
local vids = "/home/f1/data/vids"
local socket = "/tmp/vlc"

local function exec(cmd)
	local handle = io.popen(cmd)
	local result = handle:read("*a")
	handle:close()
	local result = result:gsub("[\r]?\n", "")
	return result
end

local function vlc_is_open()
	return exec("wmctrl -l | grep VLC") ~= "" or false
end

local function precheck()
	if not vlc_is_open() then
		return vim.api.nvim_err_writeln("vlc isnt open")
	end

	if not vim.loop.fs_stat(socket) then
		vim.api.nvim_err_writeln("cant find vlc unix socket at: " .. socket)
	end
end

M.save = function()
	-- fix nil error - cba to asyncify
	repeat
		time = exec([[echo "get_time" | nc -U -q0 /tmp/vlc]])
	until time:match("^%d+$")
	local time = tonumber(time)

	local title = exec([[echo "get_title" | nc -U -q0 /tmp/vlc]])
	local fp = exec(("cd %s && fd %s ."):format(vids, title))

	-- only keep parent folder
	local fp_split = vim.split(fp, "/")
	local parent = fp_split[#fp_split - 1]

	local line = ("[%s](lt://%s/%s/%s)"):format(vim.api.nvim_get_current_line(), time, parent, title)

	vim.api.nvim_set_current_line(line)
end

M.open = function()
	--precheck()
	local cline = vim.api.nvim_get_current_line()

	local time, fp
	if cline:match("%(lt://") then
		time, rel_fp = cline:match("%(lt://(%d+)/(.*)%)")
		fp = vids .. "/" .. rel_fp
	else
		vim.api.nvim_err_writeln([[current line isnt a linktrigger link: matching "(lt://"]])
		return
	end

	exec("exec vlc " .. fp .. " 2>/dev/null")
	dump(time)
	exec([[sleep 2 && echo "seek ]] .. time .. [[" | nc -U -q0 /tmp/vlc]])
end

return M

require("neorg.modules.base")
require("neorg.events")

local module = neorg.modules.create("vlc")
local log = require("neorg.external.log")

module.setup = function()
	return { success = true, requires = { "core.keybinds", "core.neorgcmd" } }
end

module.load = function()
	neorg.events.broadcast_event(neorg.events.create(module, "vlc.events.our_event"))
	module.required["core.keybinds"].register_keybinds(module.name, { "save", "open" })

	module.required["core.neorgcmd"].add_commands_from_table({
		definitions = {
			vlc = {
				save = {},
				open = {},
			},
		},
		data = {
			vlc = {
				args = 1,

				subcommands = {
					save = {
						--min_args = 2,
						name = "save",
					},
					open = {
						--max_args = 2,
						name = "open",
					},
				},
			},
		},
	})
end

module.on_event = function(event)
	if event.split_type[1] == "core.neorgcmd" then
		if event.split_type[2] == "save" then
			vim.schedule(function()
				module.public.save()
			end)
		elseif event.split_type[2] == "open" then
			vim.schedule(function()
				module.public.open()
			end)
		end
	elseif event.split_type[1] == "core.keybinds" then
		if event.split_type[2] == "vlc.save" then
			module.public.save()
		elseif event.split_type[2] == "vlc.open" then
			module.public.open()
		end
	end
end

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

module.public = {

	version = "0.1",

	save = function()
		-- fix nil error - cba to asyncify
		repeat
			time = exec([[echo "get_time" | nc -U -q0 /tmp/vlc]])
		until time:match("^%d+$")
		local time = tonumber(time)

		local title = exec([[echo "get_title" | nc -U -q0 /tmp/vlc]])
		local fp = exec(("cd %s && fd %s ."):format(vids, title))

		local line = ("[%s](lt://%s/%s)"):format(vim.api.nvim_get_current_line(), time, fp)
		vim.api.nvim_set_current_line(line)
	end,

	open = function()
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
	end,
}

module.events.defined = {

	our_event = neorg.events.define(module, "our_event"),
}

module.events.subscribed = {

	["vlc"] = {
		our_event = true,
	},
	["core.keybinds"] = {
		["vlc.save"] = true,
		["vlc.open"] = true,
	},
	["core.neorgcmd"] = {
		["open"] = true,
		["save"] = true,
	},
}

return module

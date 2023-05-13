
--[[
    DATEINSERTER
    This module is responsible for handling the insertion of date and time into a neorg buffer.
--]]

require("neorg.modules.base")
require("neorg.events")

local module = neorg.modules.create("tags")
local log = require("neorg.external.log")

module.setup = function()
	return {
		success = true,
		requires = {
			"core.norg.esupports.metagen",
			"core.neorgcmd",
		},
	}
end

module.on_event = function(event)
	if event.split_type[1] == "core.neorgcmd" then
		if event.split_type[2] == "batch" then
			vim.schedule(function()
				module.public.batch()
			end)
		end
	end
end

module.load = function()
	module.required["core.neorgcmd"].add_commands_from_table({
		definitions = {
			tag = {
				batch = {},
			},
		},
		data = {
			tag = {
				args = 1,

				subcommands = {
					batch = {
						--min_args = 2,
						name = "batch",
					},
				},
			},
		},
	})
end

module.public = {

	version = "0.1",

	batch = function()
		local Path = require("plenary.path")
		local metagen = module.required["core.norg.esupports.metagen"]
		local bufnr = vim.api.nvim_create_buf(false, true)

		local errors = {}
		local process = function(filepath)
			filepath = "/home/f1/dev/notes/linux/nvim -N"
			Path:new(filepath):_read_async(vim.schedule_wrap(function(data)
				if not vim.api.nvim_buf_is_valid(bufnr) then
					table.insert(errors, filepath)
					return
				end

				local processed_data = vim.split(data, "[\r]?\n")
				dump(processed_data)

				if processed_data then
					vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, processed_data)
				end

				-- dump(metagen.is_metadata_present(bufnr))
				dump(inject_metadata(bufnr, force))
			end))
		end

		local process_all = function(note_files)
			for _, file in ipairs(note_files) do
				if file ~= "" then
					process(file)
					break
				end

				-- print error table list after
			end
		end

		-- get all note files
		-- glow.nvim/lua/glow/init.lua
		local note_files = {}
		local opts = {
			on_sterr = vim.schedule_wrap(function(_, data, _)
				local out = table.concat(data, "\n")
				vim.notify(out, vim.log.levels.ERROR)
			end),
			on_stdout = vim.schedule_wrap(function(_, data, _)
				note_files = data
			end),
			on_exit = vim.schedule_wrap(function()
				dump("on exit")
				dump(note_files)
				process_all(note_files)
			end),
			cwd = vim.loop.os_homedir() .. "/dev/notes",
			stdout_buffered = true,
		}
		local cmd = { "fd", "-a", ".norg" }
		vim.fn.jobstart(cmd, opts)
	end,
}
module.events.subscribed = {
	["core.neorgcmd"] = {
		["batch"] = true,
	},
}
return module

-- require('neorg.modules.base')
--
--
--
-- local module = neorg.modules.create("tags")
--
--
-- module.setup = function()
--   return {
--     requires = {
--       "core.esupports.metagen"
--     }
--   }
-- end
--
-- module.load = {
--
-- }
-- module.public = {
--
--   tag = function()
--
--     dump(module.required["core.esupports.metagen"])
--   end
-- }
--
-- module.events.subscribed = {
--
--   -- ["utilities.vlc"] = {
--   --   our_event = true
--   -- },
--   -- ["core.keybinds"] = {
--   --   ["utilities.vlc.save"] = true
--   -- },
--   ["core.neorgcmd"] = {
--     ["tag"] = true,
--   }
--
-- }
--
-- return module

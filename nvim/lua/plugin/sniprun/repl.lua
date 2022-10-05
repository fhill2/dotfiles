local Repl = {}
-- turn on for the current buffer:
-- :lua require("user.functions").toggle()
--

function Repl:start()
	self.enabled = true
	self.events.on_lines = function()
		if not self.enabled then
			return true
		end
		local line_amt = #vim.api.nvim_buf_get_lines(self.bufnr, 0, -1, false)
		self.sa.run_range(1, line_amt)
	end

	self.events.on_detach = function()
		print("detached")
		if not self.enabled then
			return true
		end
	end

	vim.api.nvim_buf_attach(vim.api.nvim_get_current_buf(), false, {
		on_lines = self.events.on_lines,
		on_detach = self.events.on_detach,
	})
	print("SnipRun Live Repl Started")
end

function Repl:stop()
	self.enabled = false
	self.events.on_lines()
	print("SnipRun Live Repl Stopped")
end

function Repl:new()
	return setmetatable({
		enabled = false,
		bufnr = vim.api.nvim_get_current_buf(),
		sa = require("sniprun.api"),
		events = {},
	}, {
		__index = Repl,
	})
end

local Manager = {
	instances = {},
}

function Manager.toggle()
	bufnr = vim.api.nvim_get_current_buf()

	if not Manager.instances[bufnr] then
		Manager.instances[bufnr] = Repl.new()
	end

	if not Manager.instances[bufnr].enabled then
		Manager.instances[bufnr]:start()
	else
		Manager.instances[bufnr]:stop()
	end
end

return Manager

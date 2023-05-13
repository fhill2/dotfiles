local M = {}

M = {
	settings = {
		python = {
			formatting = { provider = "black" },
			analysis = {
				autoSearchPaths = true,
				useLibraryCodeForTypes = true,
				diagnosticMode = "workspace",
			},
		},
	},
}

local util = require("lspconfig.util")
--https://github.com/neovim/nvim-lspconfig/issues/500#issuecomment-851247107
M.get_python_path = function(workspace)
	-- use pyenv virtualenv plugin
	-- pyenv virtualenv plugin doesnt set $VIRTUAL_ENV variable, so below cant be used
	--local pyenv_activated = vim.api.nvim_exec("!pyenv local", true) ~= "system" or false
	--print("pyenv_activated is: " .. pyenv_activated)

	-- Use activated virtualenv.
	if vim.env.VIRTUAL_ENV then
		return util.path.join(vim.env.VIRTUAL_ENV, "bin", "python")
	end

	-- Check for a poetry.lock file
	if vim.fn.glob(util.path.join(workspace, "poetry.lock")) ~= "" then
		return util.path.join(vim.fn.trim(vim.fn.system("poetry env info -p")), "bin", "python")
	end

	-- Find and use virtualenv from pipenv in workspace directory.
	local match = vim.fn.glob(util.path.join(workspace, "Pipfile"))
	if match ~= "" then
		local venv = vim.fn.trim(vim.fn.system("PIPENV_PIPFILE=" .. match .. " pipenv --venv"))
		return util.path.join(venv, "bin", "python")
	end

	-- Fallback to system Python.
	return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
end

return M

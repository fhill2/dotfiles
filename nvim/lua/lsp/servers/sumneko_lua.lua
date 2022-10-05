-- https://github.com/Conni2461/dotfiles/blob/191ace7b9002547e36cf2ef26ed1f26013e6a31d/.config/nvim/lua/module/lsp.lua#L195
-- https://github.com/saurabhchardereal/dotfiles/tree/main/config/nvim
local M = {}

M = vim.tbl_deep_extend("force", require("lua-dev").setup({ snippet = false }), {
	settings = {
		Lua = {
			telemetry = {
				enable = false,
			},
			runtime = {
				version = "LuaJIT",
				path = vim.split(package.path, ";"),
			},
			diagnostics = {
				enable = true,
				globals = { "vim", "describe", "it", "before_each", "teardown", "pending" },
			},
			workspace = {
				maxPreload = 1000,
				preloadFileSize = 1000,
			},
		},
	},
})

return M

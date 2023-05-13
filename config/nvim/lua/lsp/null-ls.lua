local null_ls = require("null-ls")
local on_attach = require("lsp.events").on_attach

local actions = null_ls.builtins.code_actions
local diagnostics = null_ls.builtins.diagnostics
local formatting = null_ls.builtins.formatting

null_ls.setup({
	on_attach = on_attach,
	debounce = vim.o.updatetime,
	debug = true, -- View logs with `:NullLsLog` after setting to true
	save_after_format = false,
	sources = {
		formatting.black,
		formatting.prettierd,
		formatting.stylua,
		actions.shellcheck,
		diagnostics.shellcheck,
	},
})
table.insert(formatting.prettierd.filetypes, "ejs")

-- function M.has_formatter(ft)
--   local config = require("null-ls.config").get()
--   local formatters = config._generators["NULL_LS_FORMATTING"]
--   for _, f in ipairs(formatters) do
--     if vim.tbl_contains(f.filetypes, ft) then
--       return true
--     end
--   end
-- end

require("mason-null-ls").setup({
	-- ensure_installed = {},
	automatic_installation = true,
})

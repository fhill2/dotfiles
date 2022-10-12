local M = {}
local autocmds = require("lsp.autocmds")
local mappings = require("lsp.mappings")
local formatting = require("lsp.formatting")

M.on_attach = function(client, bufnr)
	-- Clear any autocmd declared by previous client
	vim.api.nvim_clear_autocmds({
		group = "MyLocalLSPGroup",
		buffer = bufnr,
	})


  -- vim.diagnostic.config({ virtual_lines = false })
  -- lsp_lines to show only for the current line
  vim.diagnostic.config({ virtual_lines = { only_current_line = true } })

	autocmds.attach(client, bufnr)
	formatting.attach(client, bufnr)
	mappings.attach(client, bufnr)
end

return M

local M = {}
local autocmds = require("lsp.autocmds")
local mappings = require("lsp.mappings")
local formatting = require("lsp.formatting")
local navic = require("nvim-navic")

M.on_attach = function(client, bufnr)
  -- Clear any autocmd declared by previous client
  vim.api.nvim_clear_autocmds({
    group = "MyLocalLSPGroup",
    buffer = bufnr,
  })

  -- lsp_lines config
  -- on every on_attach, disable lsp_lines, and manually enable when I need it
  vim.diagnostic.config({ virtual_lines = false })

  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
  end

  autocmds.attach(client, bufnr)
  formatting.attach(client, bufnr)
  mappings.attach(client, bufnr)
end

return M

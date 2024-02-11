local M = {}
local mapper = require("core.utils").mapper_factory
local autocmd = vim.api.nvim_create_autocmd
local command = vim.api.nvim_create_user_command

-- Useful formatting configs:
-- lua: tjdevries, elaniva, nui repo

-- Use formatters from null-ls only
local lsp_formatting = function(bufnr)
  vim.lsp.buf.format({
    -- name = "null-ls", -- Restrict formatting to client matching this name
    bufnr = bufnr,
    -- timeout = 9999999999999999,
    async = true,
  })
end

M.attach = function(client, bufnr)
  if not client.supports_method("textDocument/formatting") then
    return
  end

  -- Expose buffer-scoped variable to control autoformatting
  -- start with format on save disabled
  vim.b.format_on_save = false

  command("LspAutoFormatToggle", function()
    if not vim.b.format_on_save then
      vim.notify("Enabling auto-formatting!")
    else
      vim.notify("Disabling auto-formatting!")
    end
    vim.b.format_on_save = not vim.b.format_on_save
  end, { desc = "Toggle auto-formatting" })

  mapper({ "n", "v" })("<leader>f", function()
    lsp_formatting(bufnr)
  end, { buffer = bufnr, desc = "Format" })

  autocmd("BufWritePre", {
    group = "MyLocalLSPGroup",
    buffer = bufnr,
    callback = function()
      if not vim.b.format_on_save then
        return
      end
      lsp_formatting(bufnr)
    end,
    desc = "Format file on save",
  })
end

return M
-- https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Avoiding-LSP-formatting-conflicts
-- _G.lsp_formatting = function(bufnr)
--   vim.lsp.buf.format({
--     filter = function(clients)
--       -- filter out clients that you don't want to use
--       return vim.tbl_filter(function(client)
--         -- nothing filtered yet
--         return client
--         --return client.name ~= "tsserver"
--       end, clients)
--     end,
--     -- async = true,
--     timeout = 999999999999999,
--     bufnr = bufnr,
--   })
-- end
-- -- if you want to set up formatting on save, you can use this as a callback
-- local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
-- -- vim.cmd([[
--     command! Format execute 'lua _G.lsp_formatting()'
--     ]])

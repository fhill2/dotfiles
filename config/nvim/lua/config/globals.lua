vim.lsp.set_log_level("DEBUG")

_G._PRINT_LSP = function()
  -- get lsp
  local clients = vim.lsp.get_active_clients()
  print(vim.inspect(clients))
  require("noice").cmd("all")
  -- open the noice messages window and print it
  -- (this also refreshes the view for new messages if its open)
end

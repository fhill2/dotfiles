-- Set global updatetime (null-ls and nvim-cmp also depends on it)
vim.opt.updatetime = 400

local lspconfig = require("lspconfig")
local on_attach = require("lsp.events").on_attach

local NIL = {} -- to avoid creating a new unique table everytime

-- mason-lspconfig.nvim will error if they keys arent used
-- https://github.com/williamboman/mason-lspconfig.nvim
local servers = {
  rnix = NIL,
  bashls = NIL,
  cssls = NIL,
  dockerls = NIL,
  html = require("lsp.servers.html"),
  emmet_ls = require("lsp.servers.emmet_ls"),
  jsonls = require("lsp.servers.jsonls"),
  tsserver = require("lsp.servers.tsserver"), -- tsserver needs a npm project in root for it to start
  vimls = NIL,
  yamlls = NIL,
  tailwindcss = NIL,
  --ember = NIL,
  clangd = NIL,
  lua_ls = require("lsp.servers.lua_language_server"),
  pyright = require("lsp.servers.pyright"),
  -- rust_analyzer = NIL,
}

require("rust-tools").setup()

-- Mason config
require("mason").setup({
  ui = {
    border = "rounded",
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
})

require("mason-lspconfig").setup({
  ensure_installed = vim.tbl_keys(servers),
})

require("lsp.signs")

-- lsp_lines config
vim.diagnostic.config({ virtual_lines = false })

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
capabilities.textDocument.completion.completionItem.snippetSupport = true

servers["pyright"]["on_init"] = function(client)
  --client.config.settings.python.pythonPath = "/usr/bin/python"
  client.config.settings.python.pythonPath = require("lsp.servers.pyright").get_python_path(client.config.root_dir)
end

-- servers["pyright"]["flags"] = { allow_incremental_sync = true, debounce_text_changes = 500 }

-- Setup all listed servers
for lsp, config in pairs(servers) do
  lspconfig[lsp].setup(vim.tbl_deep_extend("force", config, {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = vim.o.updatetime,
    },
  }))
end

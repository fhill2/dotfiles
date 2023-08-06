-- https://github.com/williamboman/mason.nvim/blob/main/PACKAGES.md
require("mason").setup()

require("mason-null-ls").setup({
  ensure_installed = { "stylua", "shfmt" },
  automatic_installation = true,
})

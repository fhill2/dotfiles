local nls = require("null-ls")

local M = {}

function M.setup()
  nls.setup({
    debounce = 150,
    save_after_format = false,
    sources = {
      -- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
      -- nls.builtins.diagnostics.pylint,
      --nls.builtins.formatting.prettier,
      nls.builtins.formatting.black,
      --  nls.builtins.formatting.prettierd,
      --nls.builtins.formatting.stylua.with({
      --  extra_args = { "--config-path", vim.fn.expand("~/dev/cl/format/nui.stylua") },
      --}),

      --  nls.builtins.formatting.eslint_d,
      --  nls.builtins.diagnostics.shellcheck,
      --  nls.builtins.diagnostics.markdownlint,
      --  nls.builtins.diagnostics.selene,
      -- nls.builtins.code_actions.gitsigns,
    },
  })
end

function M.has_formatter(ft)
  local config = require("null-ls.config").get()
  local formatters = config._generators["NULL_LS_FORMATTING"]
  for _, f in ipairs(formatters) do
    if vim.tbl_contains(f.filetypes, ft) then
      return true
    end
  end
end

return M

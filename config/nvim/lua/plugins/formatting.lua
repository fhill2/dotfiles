return {
  "stevearc/conform.nvim",
  opts = {

    formatters_by_ft = {
      lua = { "stylua" },
      -- Conform will run multiple formatters sequentially
      python = { "isort", "black" },
      -- You can customize some of the format options for the filetype (:help conform.format)
      rust = { "rustfmt", lsp_format = "fallback" },
      -- Conform will run the first available formatter
      javascript = { "prettierd", "prettier", stop_after_first = true },
    },
  },
}

-- return {
--   "stevearc/conform.nvim",
--   optional = true,
--   opts = {
--     formatters_by_ft = {
--       ["markdown"] = { { "prettierd", "prettier" }, "markdownlint" },
--       ["markdown.mdx"] = { { "prettierd", "prettier" } },
--       ["javascript"] = { "dprint", { "prettierd", "prettier" } },
--       ["javascriptreact"] = { "dprint", { "prettierd", "prettier" } },
--       ["typescript"] = { "dprint", { "prettierd", "prettier" } },
--       ["typescriptreact"] = { "dprint" },
--     },
--     formatters = {
--       shfmt = {
--         prepend_args = { "-i", "2", "-ci" },
--       },
--       prettierd = {},
--       dprint = {
--         condition = function(self, ctx)
--           return vim.fs.find({ "dprint.json" }, { path = ctx.filename, upward = true })[1]
--         end,
--       },
--     },
--   },
-- }

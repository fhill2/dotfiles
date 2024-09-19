-- https://github.com/Conni2461/dotfiles/blob/191ace7b9002547e36cf2ef26ed1f26013e6a31d/.config/nvim/lua/module/lsp.lua#L195
-- https://github.com/saurabhchardereal/dotfiles/tree/main/config/nvim
local M = {}

-- https://github.com/folke/neodev.nvim
require("neodev").setup({
  -- add any options here, or leave empty to use the default settings
})

M = {
  settings = {
    Lua = {
      telemetry = {
        enable = false,
      },
      runtime = {
        version = "LuaJIT",
        path = vim.split(package.path, ";"),
      },
      -- https://github.com/hrsh7th/nvim-cmp/discussions/544
      -- complete function calls, like cmp.nvim example gif
      completion = {
        callSnippet = "Replace",
      },
      diagnostics = {
        enable = true,
        globals = { "vim", "describe", "it", "before_each", "teardown", "pending" },
      },
      workspace = {
        maxPreload = 1000,
        preloadFileSize = 1000,
        checkThirdParty = false, -- otherwise lua lsp shows popup after opening lua files in neovim
      },
    },
  },
}

return M

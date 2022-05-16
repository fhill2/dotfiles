-- local section = {
--     title = "mySection",
--     icon = "->",
--     draw = function()
--         return {
--             lines = {"hello world"},
--             hl = {
--                 -- more info see `:h nvim_buf_add_highlight()`
--                 { "CustomHighlightGroupHello", 0, 0, 5 }, -- adds `CustomHighlightGroupHello` to the word "hello"
--                 { "CustomHighlightGroupWorld", 0, 6, -1 }, -- adds `CustomHighlightGroupWorld` to the word "world"
--             },
--         }
--     end,
--     highlights = {
--         groups = { CustomHighlightGroupHello = { gui="#ff0000", fg="#00ff00", bg="#0000ff" } },
--         links = { CustomHighlightGroupWorld = "Keyword" }
--     }
-- }
--
local cwd = {
  title = "cwd",
  draw = function()
local cwd = vim.fn.getcwd():gsub(f.home, "~")
local cfile = vim.api.nvim_buf_get_name(0):gsub(f.home, "~")
    return { cwd, cfile }
  end,
}

require("sidebar-nvim").setup({
  disable_default_keybindings = 0,
  bindings = nil,
  open = false,
  side = "right",
  initial_width = 35,
  update_interval = 1000,
  --sections = { "datetime", "git-status", "lsp-diagnostics", require"plugin.sidebar.lsp-workspaces"},
  sections = { cwd, require("plugin.sidebar.lsp-workspaces") },
  section_separator = "-----",
})

-- https://github.com/dcampos/nvim-snippy/issues/9
_G.get_snippy_shell_scopes = function(scopes)
  table.insert(scopes, "shell")
  table.insert(scopes, "shell-honza")
  return scopes
end

require("snippy").setup({
  hl_group = "Search",
  snippet_dirs = _G.f.snippet_dirs,
  scopes = {
    sh = _G.get_snippy_shell_scopes,
    bash = _G.get_snippy_shell_scopes,
    zsh = _G.get_snippy_shell_scopes,
  },
  -- mappings = {
  --   is = {
  --     ['<A-i>'] = 'expand_or_advance',
  --     ['<S-Tab>'] = 'previous',
  --   },
  --   nx = {
  --     ['<leader>x'] = 'cut_text',
  --   },
  -- },
})

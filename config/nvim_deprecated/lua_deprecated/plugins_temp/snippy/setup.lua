local home = vim.loop.os_homedir()
-- https://github.com/dcampos/nvim-snippy/issues/9
_G.get_snippy_shell_scopes = function(scopes)
  table.insert(scopes, "shell")
  table.insert(scopes, "shell-honza")
  return scopes
end

-- if snippets_dirs = NIL, snippy loads any .snippet files existing within runtime_folder/snippets
-- vscode snippets are converted using snippet-converter.nvim
-- my personal snippets are symlinked from dotfiles using dotbot into eg packer_dir/my_snippets/snippets/lua.snippets

require("snippy").setup({
  hl_group = "Search",
  scopes = {
    sh = _G.get_snippy_shell_scopes,
    bash = _G.get_snippy_shell_scopes,
    zsh = _G.get_snippy_shell_scopes,
    direnv = _G.get_snippy_shell_scopes, -- need direnv.vim plugin to create direnv filetype
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

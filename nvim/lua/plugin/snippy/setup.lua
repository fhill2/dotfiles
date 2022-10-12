local home = vim.loop.os_homedir()
-- https://github.com/dcampos/nvim-snippy/issues/9
_G.get_snippy_shell_scopes = function(scopes)
	table.insert(scopes, "shell")
	table.insert(scopes, "shell-honza")
	return scopes
end

-- if snippets_dirs = NIL
-- snippy loads any runtimepath dirs that contain snippets/  - it doesn't load Ultisnips/ folder in snippets.vim
-- usually this is honza/vim-snippets/snippets
-- and friendly-snippets/snippets

-- if snippet_dirs is set in the config, snippy will only load snippets from the dirs specified
snips = home .. "/dev/snippets/snippy"
require("snippy").setup({
	hl_group = "Search",
	snippet_dirs = { snips .. "/me", snips .. "/honza" },
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

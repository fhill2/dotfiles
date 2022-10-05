local cmp = require("cmp")
local luasnip = require("luasnip")

local has_words_before = function()
	local cursor = vim.api.nvim_win_get_cursor(0)
	return not vim.api.nvim_get_current_line():sub(1, cursor[2]):match("^%s$")
end

cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	mapping = {
		--['<C-d>'] = cmp.mapping.scroll_docs(-4),
		["<C-d>"] = cmp.mapping.select_next_item(),
		["<C-s>"] = cmp.mapping.select_prev_item(),
		["<C-a>"] = cmp.mapping.confirm(),
		["<Tab>"] = cmp.mapping(function(fallback)
			vim.api.nvim_feedkeys(
				vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true),
				"",
				true
			)
		end, { "i", "s" }),
		["<C-Tab>"] = cmp.mapping(function(fallback)
			vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "", true)
		end, { "i", "s" }),
		["<C-e>"] = cmp.mapping.close(),
		["<Up>"] = cmp.mapping(function()
			vim.cmd("normal! k")
		end, { "i" }),
		["<Down>"] = cmp.mapping(function()
			vim.cmd("normal! j")
		end, { "i" }),
		["<C-Space>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
	},
	-- mapping = {
	sources = {
		-- adjust priority
		{ name = "luasnip" },
		{ name = "snippy", keyword_length = 2 },
		{ name = "nvim_lsp" },
		{ name = "nvim_lua" },
		{ name = "buffer" },
		{ name = "path" },
		{ name = "tags" },
		{ name = "orgmode" },
		{ name = "neorg" },
	},
	formatting = {
		format = function(entry, vim_item)
			-- fancy icons and a name of kind
			--vim_item.kind = require("lspkind").presets.default[vim_item.kind] .. " " .. vim_item.kind

			-- set a name for each source
			vim_item.menu = ({
				buffer = "[Buffer]",
				nvim_lsp = "[LSP]",
				luasnip = "[LuaSnip]",
				nvim_lua = "[Lua]",
				latex_symbols = "[Latex]",
			})[entry.source.name]
			return vim_item
		end,
	},
})

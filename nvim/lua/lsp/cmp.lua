-- nvim-cmp setup
local autopairs = require("nvim-autopairs.completion.cmp")
local cmp = require("cmp")
local luasnip = require("luasnip")
local ts_utils = require("nvim-treesitter.ts_utils")

-- local has_words_before = function()
-- 	local cursor = vim.api.nvim_win_get_cursor(0)
-- 	return not vim.api.nvim_get_current_line():sub(1, cursor[2]):match("^%s$")
-- end
--
-- Kind symbols
local cmp_kind_icons = {
	Class = "ﴯ",
	Color = "",
	Constant = "",
	Constructor = "",
	Enum = "",
	EnumMember = "",
	Event = "",
	Field = "ﰠ",
	File = "",
	Folder = "",
	Function = "",
	Interface = "",
	Keyword = "",
	Method = "",
	Module = "",
	Operator = "",
	Property = "ﰠ",
	Reference = "",
	Snippet = "",
	Struct = "פּ",
	Text = "",
	TypeParameter = "",
	Unit = "塞",
	Value = "",
	Variable = "",
}

cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	formatting = {
		format = function(entry, vim_item)
			vim_item.kind = string.format("%s %s", cmp_kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
			vim_item.menu = ({
				buffer = "[Buffer]",
				nvim_lsp = "[LSP]",
				luasnip = "[LuaSnip]",
				nvim_lua = "[Lua]",
				latex_symbols = "[Latex]",
				snippy = "[Snippy]",
			})[entry.source.name]
			return vim_item
		end,
	},
	window = {
		-- completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-u>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		-- ["<CR>"] = cmp.mapping.confirm({
		-- 	behavior = cmp.ConfirmBehavior.Replace,
		-- 	-- select = true,
		-- }),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	}),

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
})

-- Autopairs for completion items
-- @see https://github.com/NvChad/NvChad/pull/1095
local filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" }

cmp.event:on("confirm_done", function(event)
	local filetype = vim.bo.filetype

	-- Do not complete autopairs in import statements
	if vim.tbl_contains(filetypes, filetype) then
		local node_type = ts_utils.get_node_at_cursor():type()
		if node_type ~= "named_imports" then
			autopairs.on_confirm_done()(event)
		end
	else
		autopairs.on_confirm_done()(event)
	end
end)

-- Make <CR> autoselect first completion item in html files
cmp.setup.filetype("html", {
	mapping = cmp.mapping.preset.insert({
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
	}),
})

-- Set configuration for specific filetype.
cmp.setup.filetype("gitcommit", {
	sources = {
		{ name = "cmp_git" },
		{ name = "buffer" },
		{ name = "path" },
	},
})

-- mapping = {
-- 	--['<C-d>'] = cmp.mapping.scroll_docs(-4),
-- 	["<C-d>"] = cmp.mapping.select_next_item(),
-- 	["<C-s>"] = cmp.mapping.select_prev_item(),
-- 	["<C-a>"] = cmp.mapping.confirm(),
-- 	["<Tab>"] = cmp.mapping(function(fallback)
-- 		vim.api.nvim_feedkeys(
-- 			vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true),
-- 			"",
-- 			true
-- 		)
-- 	end, { "i", "s" }),
-- 	["<C-Tab>"] = cmp.mapping(function(fallback)
-- 		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "", true)
-- 	end, { "i", "s" }),
-- 	["<C-e>"] = cmp.mapping.close(),
-- 	["<Up>"] = cmp.mapping(function()
-- 		vim.cmd("normal! k")
-- 	end, { "i" }),
-- 	["<Down>"] = cmp.mapping(function()
-- 		vim.cmd("normal! j")
-- 	end, { "i" }),
-- 	["<C-Space>"] = cmp.mapping.confirm({
-- 		behavior = cmp.ConfirmBehavior.Replace,
-- 		select = true,
-- 	}),
-- },

-- nvim-cmp setup
local autopairs = require("nvim-autopairs.completion.cmp")
local cmp = require("cmp")
-- local luasnip = require("luasnip")
local snippy = require("snippy")
local ts_utils = require("nvim-treesitter.ts_utils")

local has_words_before = function()
	local cursor = vim.api.nvim_win_get_cursor(0)
	return not vim.api.nvim_get_current_line():sub(1, cursor[2]):match("^%s$")
end
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
	performance = {
		-- the popup window freezes on large projects due to a large amount of results
		max_view_entries = 20,
	},
	snippet = {
		expand = function(args)
			dump("snippy trig")
			-- require("luasnip").lsp_expand(args.body)
			require("snippy").expand_snippet(args.body) -- For `snippy` users.
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
	experimental = {
		ghost_text = true,
	},
	window = {
		-- completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	--  elianava dotfiles
	mapping = {
		-- ["<Tab>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
		-- ["<S-Tab>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif snippy.can_expand_or_advance() then
				snippy.expand_or_advance()
			elseif has_words_before() then
				cmp.complete()
			else
				fallback()
			end
		end, { "i", "s" }),

		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif snippy.can_jump(-1) then
				snippy.previous()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-d>"] = cmp.mapping.scroll_docs(4),
		["<C-u>"] = cmp.mapping.scroll_docs(-4),
		["<C-e>"] = cmp.mapping.close(),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Insert,
			select = true,
		}),

		-- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings
		-- safe <CR>
		-- ["<CR>"] = cmp.mapping({
		--   i = function(fallback)
		--     if cmp.visible() and cmp.get_active_entry() then
		--       cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
		--     else
		--       fallback()
		--     end
		--   end,
		--   s = cmp.mapping.confirm({ select = true }),
		--   c = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true }),
		-- }),
	},
	-- mapping = cmp.mapping.preset.insert({
	-- 	["<C-d>"] = cmp.mapping.scroll_docs(-4),
	-- 	["<C-u>"] = cmp.mapping.scroll_docs(4),
	-- 	["<C-Space>"] = cmp.mapping.complete(),
	-- 	-- ["<CR>"] = cmp.mapping.confirm({
	-- 	-- 	behavior = cmp.ConfirmBehavior.Replace,
	-- 	-- 	-- select = true,
	-- 	-- }),
	-- 	["<Tab>"] = cmp.mapping(function(fallback)
	-- 		if cmp.visible() then
	-- 			cmp.select_next_item()
	-- 		elseif luasnip.expand_or_jumpable() then
	-- 			luasnip.expand_or_jump()
	-- 		else
	-- 			fallback()
	-- 		end
	-- 	end, { "i", "s" }),
	-- 	["<S-Tab>"] = cmp.mapping(function(fallback)
	-- 		if cmp.visible() then
	-- 			cmp.select_prev_item()
	-- 		elseif luasnip.jumpable(-1) then
	-- 			luasnip.jump(-1)
	-- 		else
	-- 			fallback()
	-- 		end
	-- 	end, { "i", "s" }),
	-- }),
	--
	sources = {
		-- adjust priority
		{ name = "copilot" },
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

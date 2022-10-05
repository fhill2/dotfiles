local wk = require("which-key")
--if leader key is space all of my custom mappings are added with mappings added by plugins
vim.g.mapleader = [[\]]
vim.g.maplocalleader = ","

wk.setup({ -- custom config
})

local normal_keymaps = {
	-- a = {
	--   function()
	--     require("plugin.nui.popup").popup({ close = true })
	--   end,
	--   "nui - close all floating windows",
	-- },
	a = {
		--    ["h"] = {
		--      function()
		--        require("util/old").send({ whole = true })
		--      end,
		--      "old - send whole file open window",
		--    },
		--
		--    o = {
		--    ["j"] = {
		--      function()
		--        require("util/old").show()
		--      end,
		--      "old - open window",
		--    },
		--  },

		["d"] = { "<cmd>vsp<cr>", "new | window" },
		["s"] = { "<cmd>sp<cr>", "new -- window" },
		["f"] = { "<cmd>bo 30split<cr>", "new btm window" },
		["a"] = { "<cmd>to 31split<cr>", "new top window " },
	},
	b = {
		name = "+buffer",
		["b"] = { "<cmd>Telescope buffers show_all_buffers=true<cr>", "telescope Buffers" },
		["c"] = { "<cmd>Bdelete!<cr>", "Delete buffer (without closing window)" },
		["p"] = { "<cmd>:BufferLineCyclePrev<CR>", "Previous Buffer" },
		["["] = { "<cmd>:BufferLineCyclePrev<CR>", "Previous Buffer" },
		["n"] = { "<cmd>:BufferLineCycleNext<CR>", "Next Buffer" },
		["]"] = { "<cmd>:BufferLineCycleNext<CR>", "Next Buffer" },
		["g"] = { "<cmd>:BufferLinePick<CR>", "Goto Buffer" },
		-- "b"] = { "<cmd>:e #<cr>", "Switch to Other Buffer" },
		--["d"] = { "<cmd>:bd<CR>", "Delete Buffer" },
	},
	-- c = { "<cmd>NvimTreeToggle<cr>", "NvimTreeToggle" },
	s = {
		name = "+search",
		["s"] = {
			"<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>",
			"Telescope live_grep_args",
		},
		["d"] = { "<cmd>Telescope live_grep<cr>", "telescope Live_Grep cwd interactive" },
		["b"] = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Buffer" },
		["h"] = { "<cmd>Telescope command_history<cr>", "Command History" },
		["m"] = { "<cmd>Telescope marks<cr>", "Jump to Mark" },

		["r"] = { "<cmd>lua require('spectre').open()<CR>", "Replace (Spectre)" },
	},
	d = {
		name = "+debug",
		["d"] = { "<Cmd>silent lua require'dap'.continue()<CR>", "dap - continue" },
		-- ["s"] = { "<Cmd>silent lua require'dap'.step_over()<CR>", "dap - step over" },
		-- ["f"] = { "<Cmd>silent lua require'dap'.step_into()<CR>", "dap - step into" },
		-- ["a"] = { "<Cmd>silent lua require'dap'.step_out()<CR>", "dap - step out" },
		["s"] = { "<Cmd>silent lua require'dap'.terminate()<CR>", "dap - terminate" },
		["b"] = { "<Cmd>silent lua require'dap'.toggle_breakpoint()<CR>", "dap - toggle breakpoint" },
		["B"] = {
			"<Cmd>silent lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
			"dap - set breakpoint condition",
		},
		["N"] = {
			"<Cmd>silent lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>",
			"dap - set breakpoint log",
		},
		["r"] = { "<Cmd>silent lua require'dap'.repl.open()<CR>", "dap - open repl" },
		["f"] = { "<Cmd>silent lua require'dap'.run_last()<CR>", "dap - last run" },
	},
	e = {
		name = "+errors",
		["x"] = { "<cmd>TroubleToggle<cr>", "Trouble" },
		["w"] = { "<cmd>TroubleWorkspaceToggle<cr>", "Workspace Trouble" },
		["d"] = { "<cmd>TroubleDocumentToggle<cr>", "Document Trouble" },
		["t"] = { "<cmd>TodoTrouble<cr>", "Todo Trouble" },
		["T"] = { "<cmd>TodoTelescope<cr>", "Todo Telescope" },
		["l"] = { "<cmd>lopen<cr>", "Open Location List" },
		["q"] = { "<cmd>copen<cr>", "Open Quickfix List" },
	},
	l = {
		name = "+legendary",
		["k"] = {
			function()
				require("legendary").find("keymaps")
			end,
			"Legendary - Keymaps",
		},
		--["c"] = { function() require('legendary').find('commands') end, "Legendary - Commands" },
		["l"] = {
			function()
				require("plugin.legendary").find_by_desc("[LSP]")
			end,
			"Legendary - [LSP]",
		},
	},
	m = {
		name = "+snippets",
		["m"] = {
			function()
				require("plugin.telescope.snippy").show()
			end,
			"show snippets [Snippy]",
		},
	},

	q = {
		name = "+qf",
		["q"] = { [[<cmd>:copen<cr>]], "open qf" },
		["w"] = { [[<cmd>call asyncrun#quickfix_toggle(8)<cr>]], "toggle quickfix list unfocused" },
	},
	r = {
		name = "+run",
		["r"] = { [[<cmd>lua require"util.run.init".run()<cr>]], "run" },
		["q"] = { [[<cmd>lua require"util.run.init".run_qtile()<cr>]], "run qtile" },
	},
	f = {
		name = "+files",
		-- ["g"] = { '<cmd>lua require("plugin.telescope.wrap").ff_files_home()<cr>', "Telescope - files - home" },
		-- ["f"] = { '<cmd>lua require("plugin.telescope.wrap").ff_files()<cr>', "Telescope - files - cwd" },
		["d"] = { '<cmd>lua require("plugin.telescope.wrap").fb_dot()<cr>', "Telescope fb - dotfiles" },
		["f"] = { '<cmd>lua require("plugin.telescope.wrap").fb_cwd()<cr>', "Telescope fb  - cwd" },
		["v"] = { '<cmd>lua require("plugin.telescope.wrap").fb_dev()<cr>', "Telescope fb - dev" },
		["h"] = { '<cmd>lua require("plugin.telescope.wrap").fb_home()<cr>', "Telescope fb - home" },
		["r"] = { '<cmd>lua require("plugin.telescope.wrap").fb_repos()<cr>', "Telescope fb - repos" },
		["n"] = { '<cmd>lua require("plugin.telescope.wrap").fb_notes()<cr>', "Telescope fb - notes" },
		["m"] = { '<cmd>lua require("plugin.telescope.wrap").fb_notes_tags()<cr>', "Telescope fb - notes tags" },
		["b"] = { '<cmd>lua require("plugin.telescope.wrap").fb_cbuf()<cr>', "telescope fb - current buffer" },
		["o"] = { '<cmd>lua require("plugin.telescope.wrap").fb_old()<cr>', "telescope fb - old" },
		["j"] = { '<cmd>lua require("plugin.telescope.wrap").fb()<cr>', "telescope fb" },
		["a"] = { '<cmd>lua require("plugin.telescope.wrap").fb_repos_flat()<cr>', "telescope fb - repos-flat" },
		["s"] = { '<cmd>lua require("plugin.telescope.wrap").fb_repos_tags()<cr>', "telescope fb - repos-tags" },
		["p"] = { '<cmd>lua require("plugin.telescope.wrap").python()<cr>', "telescope fb - python" },
		["q"] = { "<cmd>Telescope find_files<cr>", "telescope Find Files" },
		["t"] = { "<cmd>Telescope oldfiles<cr>", "telescope oldfiles (recent)" },
	},
	-- p = {
	--   name = "+neorg",
	--   ["p"] = { "<cmd>Neorg vlc save<cr>", "vlc save link" },
	--   ["o"] = { "<cmd>Neorg vlc open<cr>", "vlc open link" },
	-- },
	p = {
		function()
			require("legendary").find({ kind = "commands" })
		end,
		"Legendary - Commands",
	},
	w = {
		name = "+windows",
		["e"] = { "<C-W>p", "other-window" },
		["w"] = { "<C-W>c", "close-window" },
		["-"] = { "<C-W>s", "split-window-below" },
		["|"] = { "<C-W>v", "split-window-right" },
		["2"] = { "<C-W>v", "layout-double-columns" },
		["j"] = { "<C-W>h", "window-left" },
		["h"] = { "<C-W>j", "window-below" },
		["k"] = { "<C-W>l", "window-right" },
		["l"] = { "<C-W>k", "window-up" },
		["H"] = { "<C-W>5<", "expand-window-left" },
		["J"] = { ":resize +5", "expand-window-below" },
		["L"] = { "<C-W>5>", "expand-window-right" },
		["K"] = { ":resize -5", "expand-window-up" },
		["="] = { "<C-W>=", "balance-window" },
		["s"] = { "<C-W>s", "split-window-below" },
		["v"] = { "<C-W>v", "split-window-right" },
	},
	--["`"] = { "<cmd>:e #<cr>", "prev<->current buffer" },
	["<space>"] = {
		function()
			--require("plugin.telescope.find_frecency").show({ cwd = '/home/f1/dev/notes'})
			-- require("plugin.telescope.wrap").ff_files_dirs_home()
			--{ cwd = '/home/f1/dev/notes/dev/dev-linux/nvim' }
		end,
		"telescope find_frecency",
	},
	["<space>"] = { "<cmd>Telescope resume<cr>", "Telescope resume" },
	["?"] = {
		[[<cmd>lua require"cheatsheet".show_cheatsheet_telescope({bundled_cheatsheets=false, bundled_plugin_cheatsheets=false})<cr>]],
		"split-window-right",
	},
}

wk.register(normal_keymaps, { prefix = "<space>" })
-- false=which-key binds them, true=legendary binds them
require("legendary").bind_whichkey(normal_keymaps, { prefix = "<space>" }, false)

-- visual mode mappings
local visual_keymaps = {
	o = {
		function()
			require("util/old").send()
		end,
		"old - send visual",
	},
	m = {
		name = "+snippets",
		["m"] = {
			function()
				require("plugin.snippy.save").save_snippet()
			end,
			"save snippet - visual [Snippy]",
		},
	},

	p = {
		function()
			require("legendary").find("commands")
		end,
		"Legendary - Commands",
	},
	l = {
		name = "+legendary",
		["k"] = {
			function()
				require("legendary").find("keymaps")
			end,
			"Legendary - Keymaps",
		},
		["l"] = {
			function()
				require("plugin.legendary").find_by_desc("[LSP]")
			end,
			"Legendary - [LSP]",
		},
	},
	f = {
		function()
			_G.format_github_repos_dotbot()
		end,
		"dotbot - format github repos yaml",
	},
}

wk.register(visual_keymaps, { prefix = "<space>", mode = "v" })
require("legendary").bind_whichkey(visual_keymaps, { prefix = "<space>", mode = "v" }, false)

local a = require("util/keymap")

--- NORMAL MAPPINGS ----

-- as tab is autocomplete, set normal tab as S-Tab
a.inoremap("<S-Tab>", "<Tab>")

-- a.allremap("<C-Space>", [[<cmd>luafile %<cr>]])

local opts = { noremap = true } -- silent = true
-- vim.keymap.set("n", "<C-Space>", telescope_actions.close_picker, {})
-- vim.keymap.set("i", "<C-Space>", telescope_actions.close_picker, {})

-- SPLITS FOCUSING
a.nnoremap("<C-h>", "<C-w>h")
a.nnoremap("<C-j>", "<C-w>j")
a.nnoremap("<C-k>", "<C-w>k")
a.nnoremap("<C-l>", "<C-w>l")

a.nnoremap(";", "<cmd>write<cr>")
a.allremap("<F14>", "<cmd>qa!<cr>")

-- cut copy paste undo
--api.nvim_set_keymap('', '<C-x>', 'd', {})
--api.nvim_set_keymap('!', '<C-x>', '<Esc>d', {})
--a.vnoremap("<C-x>", "<Esc>d")
--a.vnoremap("<C-c>", "y<Esc>")

a.inoremap("<C-h>", "<Left>")
a.inoremap("<C-j>", "<Down>")
a.inoremap("<C-k>", "<Up>")
a.inoremap("<C-l>", "<Right>")
a.cnoremap("<C-h>", "<Left>")
a.cnoremap("<C-j>", "<Down>")
a.cnoremap("<C-k>", "<Up>")
a.cnoremap("<C-l>", "<Right>")

a.nnoremap("<C-Space>", [[<cmd>lua require"plugin.telescope.actions".toggle_focus_picker()<cr>]])
a.inoremap("<C-Space>", [[<cmd>lua require"plugin.telescope.actions".toggle_focus_picker()<cr>]])
a.nnoremap("<C-a>", [[<cmd>lua require"plugin.telescope.actions".toggle_focus_previewer()<cr>]])
a.inoremap("<C-a>", [[<cmd>lua require"plugin.telescope.actions".toggle_focus_previewer()<cr>]])

a.nnoremap("<C-.>", [[<cmd>lua require"plugin.telescope.actions".close_or_resume()<cr>]])
a.inoremap("<C-.>", [[<cmd>lua require"plugin.telescope.actions".close_or_resume()<cr>]])

-- :h dap-mappings
vim.cmd([[nnoremap <silent> <F5> <Cmd>lua require'dap'.continue()<CR>]])
vim.cmd([[nnoremap <silent> <F10> <Cmd>lua require'dap'.step_over()<CR>]])
vim.cmd([[nnoremap <silent> <F11> <Cmd>lua require'dap'.step_into()<CR>]])
vim.cmd([[nnoremap <silent> <F12> <Cmd>lua require'dap'.step_out()<CR>]])
-- vim.cmd[[nnoremap <silent> <Leader>b <Cmd>lua require'dap'.toggle_breakpoint()<CR>]]
-- vim.cmd[[nnoremap <silent> <Leader>B <Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>]]
-- vim.cmd[[nnoremap <silent> <Leader>lp <Cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>]]
-- vim.cmd[[nnoremap <silent> <Leader>dr <Cmd>lua require'dap'.repl.open()<CR>]]
-- vim.cmd[[nnoremap <silent> <Leader>dl <Cmd>lua require'dap'.run_last()<CR>]]

-- _G.set_magma_keymaps = function(buf)
--   dump(buf)
-- end

vim.api.nvim_create_autocmd("FileType", {
	pattern = "json",
	callback = function(opts)
		keymap_opts = { silent = true, noremap = true }
		vim.api.nvim_buf_set_keymap(opts.buf, "n", "<leader>rr", "<cmd>MagmaEvaluateLine<cr>", keymap_opts)
		vim.api.nvim_buf_set_keymap(opts.buf, "n", "<leader>rv", "<cmd>MagmaEvaluateVisual<cr>", keymap_opts)
		vim.api.nvim_buf_set_keymap(opts.buf, "n", "<leader>rf", "<cmd>MagmaReevaluateCell<cr>", keymap_opts)
		vim.api.nvim_buf_set_keymap(opts.buf, "n", "<leader>rd", "<cmd>MagmaDelete<cr>", keymap_opts)
		vim.api.nvim_buf_set_keymap(opts.buf, "n", "<leader>ro", "<cmd>MagmaShowOutput<cr>", keymap_opts)
	end,
})

-- commands not added
-- :MagmaShowOutput
-- :MagmaInterrupt
-- MagmaRestart
-- MagmaRestart!
--
-- nnoremap <silent><expr> <localleader>r  :magmaevaluateoperator<cr>
-- nnoremap <silent>       <localleader>rr :magmaevaluateline<cr>
-- xnoremap <silent>       <localleader>r  :<c-u>magmaevaluatevisual<cr>
-- nnoremap <silent>       <localleader>rc :magmareevaluatecell<cr>
-- nnoremap <silent>       <localleader>rd :magmadelete<cr>
-- nnoremap <silent>       <localleader>ro :magmashowoutput<cr>
--
-- let g:magma_automatically_open_output = v:false
-- let g:magma_image_provider = "ueberzug"

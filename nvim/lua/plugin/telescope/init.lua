----- only startup config here
local telescope = require("telescope")
local fb_actions = require("telescope").extensions.file_browser.actions
local actions = require("telescope.actions")
local layout_actions = require("telescope.actions.layout")
-- local action_state = require("telescope.actions.state")
-- local action_set = require("telescope.actions.set")
local my_actions = require("plugin.telescope.actions")
-- local my_utils = require("plugin.telescope.util")
-- local lga_actions = require("telescope-live-grep-args.actions")
local conf = require("telescope.config").values

-- live-grep-args and anything relying on ripgrep should follow symlinked directories to find results
table.insert(conf.vimgrep_arguments, "-L")

_G.current_editor_win = 1000
_G.telescope_get_current_editor_win = function()
	local c_win = vim.api.nvim_get_current_win()
	if vim.tbl_contains(require("plugin.telescope.util").get_editor_wins_no_previewer(), c_win) then
		_G.current_editor_win = c_win
	end
end
vim.cmd([[autocmd WinEnter * lua _G.telescope_get_current_editor_win()]])

_G.telescope_fb_repo_resolver = function(cb)
	-- called from fb_actions.change_cwd()
	-- called from fb_cwd wrap.lua
	-- this is because cding into a symlinked directory always resolves the symlink and this cant be configured in neovim
	local home = vim.loop.os_homedir()
	local cwd = vim.loop.cwd()
	local packer = table.concat({ vim.fn.stdpath("data"), "site", "pack", "packer" }, "/")
	local repos = table.concat({ home, "repos" }, "/")
	if vim.startswith(cwd, packer) or vim.startswith(cwd, repos) then
		return cb()
	end
	return false
end

local telescope_mappings = {
	i = {
		-- fb_actions in global telescope mappings so I can use the filesystem actions in other pickers (actions need customisation)
		["<C-j>"] = actions.move_selection_next,
		["<C-o>"] = my_actions.resize,
		["<C-k>"] = actions.move_selection_previous,
		["<C-[>"] = layout_actions.cycle_layout_prev,
		["<C-]>"] = layout_actions.cycle_layout_next,
		-- ["<C-Space>"] = my_actions.toggle_focus_picker,
		["<S-CR>"] = actions.select_horizontal,
		-- ["<C-a>"] = my_actions.toggle_focus_previewer,
		["<C-n>"] = fb_actions.create,
		["<C-r>"] = fb_actions.rename,
		["<C-v>"] = fb_actions.copy,
		["<C-x>"] = fb_actions.remove,
		["<C-b>"] = fb_actions.move,
		["<F1>"] = actions.which_key,
		["<C-p>"] = require("telescope.actions.layout").toggle_preview,
		["<C-w>"] = actions.send_selected_to_qflist,
		["<C-q>"] = actions.send_to_qflist,
		["<C-.>"] = my_actions.close_or_resume,
	},
	n = {
		["<C-Space>"] = my_actions.close_picker,
		["<F1>"] = actions.which_key,
		["<C-w>"] = actions.send_selected_to_qflist,
		["<C-q>"] = actions.send_to_qflist,
		["<S-n>"] = fb_actions.create_from_prompt,
	},
}

local file_browser_mappings = {
	i = {
		["<C-h>"] = fb_actions.goto_home_dir,
		["<C-e>"] = fb_actions.change_cwd,

		-- duplicate default mappings
		["<A-c>"] = false, -- create
		["<A-r>"] = false, -- rename
		["<A-y>"] = false, -- copy
		["<A-d>"] = false, -- remove
		["<A-m>"] = false, -- move
		["<C-1>"] = fb_actions.sort_by_date_once,
		["<C-2>"] = my_actions.fb_change_depth,
		-- ["<C-2>"] = fb_actions.sort_by_size
	},
	-- ["n"] = ,
}

local cycle_layout_list = {
	{
		layout_strategy = "vertical",
		layout_config = { preview_height = 20 },
	},
	"horizontal",
	"vertical",
}

local defaults = {
	-- border = true,
	-- borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
	layout_strategy = "vertical",
	layout_config = {
		height = 0.99,
		width = 0.99,
		prompt_position = "bottom",
		preview_cutoff = 1,
		anchor = "S",
		-- preview_height = 40, -- adding this breaks vim.ui.select legendary.nvim
	},
	cycle_layout_list = cycle_layout_list,
	prompt_prefix = " ",
	sorting_strategy = "descending",
	cache_picker = {
		num_pickers = 20,
	},
	dynamic_preview_title = true,
	cache_picker = {
		num_pickers = 20,
	},
	-- toggle_focus_previewer and toggle_focus_picker dont work here
	mappings = telescope_mappings,
}

local extensions = {
	file_browser = {
		-- path_display = { absolute = true },
		depth = false,
		add_dirs = true,
		hidden = true,
		cwd_to_path = true,
		mappings = file_browser_mappings,
	},
	live_grep_args = {
		auto_quoting = true, -- enable/disable auto-quoting
		mappings = {
			i = {
				-- ["<C-k>"] = lga_actions.quote_prompt(),
				-- ["<C-l>g"] = lga_actions.quote_prompt({ postfix = ' --iglob ' }),
				-- ["<C-l>t"] = lga_actions.quote_prompt({ postfix = ' -t' }),
			},
		},
	},
	-- these extra sorter are mutually exclusive
	-- fzf takes precedence as it is loaded after with load_extension()
	-- make sure there is only 1 override per sorter
	fzy_native = {
		override_generic_sorter = false, -- conf.generic_sorter() will load ffi fzy native
		override_file_sorter = false, -- conf.file_sorter() will load ffi fzy native
	},
	fzf = {
		fuzzy = false, -- false will only do exact matching
		override_generic_sorter = true, -- override the generic sorter
		override_file_sorter = true, -- override the file sorter
		case_mode = "smart_case", -- or "ignore_case" or "respect_case"
		-- the default case_mode is "smart_case"
	},
	bookmarks = {
		selected_browser = "buku",
		buku_include_tags = true,
	},
}

require("telescope").setup({
	defaults = defaults,
	extensions = extensions,
	-- pickers = {
	--   find_files = {
	--   },
	-- }
})

telescope.load_extension("fzy_native")
telescope.load_extension("file_browser")
telescope.load_extension("repo")
telescope.load_extension("frecency")
telescope.load_extension("zoxide")
telescope.load_extension("gh")
telescope.load_extension("live_grep_args")
telescope.load_extension("bookmarks")
telescope.load_extension("git_worktree")
telescope.load_extension("notify")
--telescope.load_extension("fzf")
-- telescope.load_extension("ui-select")
--telescope.load_extension('snippets')
--telescope.load_extension("cheat")
--telescope.load_extension("projects")

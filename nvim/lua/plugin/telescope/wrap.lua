-- [WIP]
-- extension wrapper
-- local notes_cwd = "/home/f1/dev/notes"
local home = vim.loop.os_homedir()
-- local utils = require "plugin.telescope.util"
local fb_actions = require("telescope").extensions.file_browser.actions
local actions = require("telescope.actions")
local my_actions = require("plugin.telescope.actions")
-- local action_state = require "telescope.actions.state"
local wrap = {}

-- why? I can't find a way to for telescope-file-browser extension only
-- _TelescopeFileBrowserConfig = require "telescope".extensions.file_browser.config.values
-- _TelescopeFileBrowserConfig = require "telescope._extensions.file_browser.config".values
--
-- local defaults = {
--
-- attach_mappings = function(_, map)
--     _TelescopeFileBrowserConfig.attach_mappings(_, map)
--       return false
--     end,
--
-- }
--
local fb = function(opts)
	-- require "telescope".extensions.file_browser.file_browser(vim.tbl_deep_extend("keep", opts, defaults))
	require("telescope").extensions.file_browser.file_browser(opts)
end

-- local merge = function(defaults, opts)
--     return opts and vim.tbl_deep_extend("force", defaults, opts) or defaults
-- end

function wrap.fb(opts)
	-- fb(merge({ cwd_to_path = false}, opts))
	fb({ cwd_to_path = false })
end

function wrap.fb_cbuf()
	fb({
		path = vim.fn.expand("%:p:h"),
		select_buffer = true,
	})
end

function wrap.fb_dot()
	path = home .. "/dot"
	fb({
		path = path,
		initial_sort = true,
	})
end

function wrap.fb_cwd()
	local path = _G.telescope_fb_repo_resolver(function()
		return _G.fb_current_dir
	end)
	fb({ path = path })
end

function wrap.fb_dev()
	local path = home .. "/dev"
	fb({
		path = path,
		-- attach_mappings = gen_mappings(path),
	})
end

function wrap.fb_home()
	local path = home
	fb({
		path = path,
		-- attach_mappings = gen_mappings(path),
	})
end

function wrap.fb_repos_flat()
	local path = home .. "/repos-flat"
	fb({ path = path })
end
function wrap.fb_repos_tags()
	local path = home .. "/repos-tags"
	fb({ path = path })
end

function wrap.fb_old()
	local old_path = require("util.old").get_old_path()
	while not vim.loop.fs_stat(old_path.filename) do
		old_path = old_path:parent()
	end

	fb({
		path = old_path.filename,
	})
end

function wrap.fb_notes()
	local path = home .. "/dev/notes"
	fb({
		path = path,
		initial_sort = true,
	})
end
function wrap.fb_notes_tags()
	local path = home .. "/notes-tags"
	fb({
		path = path,
		-- initial_sort = true
	})
end

function wrap.buku()
	-- because I can't add mappings = {} to extension config in telescope.init.setup()
	require("telescope").extensions.bookmarks.bookmarks({
		attach_mappings = function(_, map)
			map("i", "<C-1>", my_actions.edit_bookmark_name)
			map("i", "<C-2>", my_actions.edit_bookmark_tags)
			map("i", "<C-3>", my_actions.edit_bookmark_url)
			map("i", "<C-4>", my_actions.toggle_preview)
			map("i", "<C-j>", my_actions.preview_next)
			map("i", "<C-k>", my_actions.preview_previous)
			map("i", "<Down>", my_actions.preview_next)
			map("i", "<Up>", my_actions.preview_previous)
			map("i", "<C-c>", my_actions.copy_bookmark_to_clipboard)
			map("i", "<C-x>", my_actions.delete_bookmark)
			-- map("i", "<C-v>", my_actions.get_row)
			return true
		end,
	})
end

function wrap.python()
	path = home .. "/a/python"
	fb({
		path = path,
	})
end

return wrap

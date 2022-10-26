version = "0.19.0"
local home = os.getenv("HOME")
local xpm_path = home .. "/.local/share/xplr/dtomvan/xpm.xplr"
local xpm_url = "https://github.com/dtomvan/xpm.xplr"

package.path = package.path .. ";" .. xpm_path .. "/?.lua;" .. xpm_path .. "/?/init.lua"

os.execute(string.format("[ -e '%s' ] || git clone '%s' '%s'", xpm_path, xpm_url, xpm_path))

local root_onkey = xplr.config.modes.builtin.default.key_bindings.on_key
-- TODO:
-- hide/show selection/help
-- create vertical layout with horizontal help column
-- map select to tab also
-- create mode as ctr+n - how to create both files and dirs with the same hotkey?

local dual_pane_setup = function()
	require("dual-pane").setup({
		active_pane_width = { Percentage = 50 },
		inactive_pane_width = { Percentage = 50 },
	})

	xplr.config.modes.builtin.default.key_bindings.on_key["ctrl-h"] = {
		help = "left pane",
		messages = {
			"PopMode",
			{ CallLuaSilently = "custom.dual_pane.activate_left_pane" },
		},
	}

	xplr.config.modes.builtin.default.key_bindings.on_key["ctrl-l"] = {
		help = "right pane",
		messages = {
			"PopMode",
			{ CallLuaSilently = "custom.dual_pane.activate_right_pane" },
		},
	}

	xplr.config.modes.builtin.default.key_bindings.on_key["`"] = {
		help = "toggle pane",
		messages = {
			"PopMode",
			{ CallLuaSilently = "custom.dual_pane.toggle_pane" },
		},
	}

	xplr.config.modes.builtin.default.key_bindings.on_key[";"] = {
		help = "quit pane",
		messages = {
			"PopMode",
			{ CallLuaSilently = "custom.dual_pane.quit_active_pane" },
		},
	}
end

-- https://github.com/dtomvan/xpm.xplr
require("xpm").setup({
	plugins = {
		-- Let xpm manage itself
		"dtomvan/xpm.xplr",
		"sayanarijit/preview-tabbed.xplr",
		{
			name = "sayanarijit/dual-pane.xplr",
			setup = dual_pane_setup,
		},
		"sayanarijit/trash-cli.xplr",
		"sayanarijit/find.xplr",
		"sayanarijit/map.xplr",
	},
	auto_install = true,
	auto_cleanup = true,
})

-- add extra mappings for dual-pane
-- local on_key = xplr.config.modes.builtin.switch_layout.key_bindings.on_key
-- on_key[""]

-- https://github.com/sayanarijit/dual-pane.xplr
require("preview-tabbed").setup({
	mode = "default",
	key = "ctrl-p",
	fifo_path = "/tmp/xplr.fifo",
	previewer = os.getenv("HOME") .. "/dev/bin/preview_tui_orig.sh", -- for wayland sway
	-- previewer = os.getenv("HOME") .. "/dev/bin/preview_tabbed.bash", -- for x i3 - as non TUI previewers use xembed client / host model
})

-- https://github.com/sayanarijit/trash-cli.xplr
require("trash-cli").setup({
	trash_mode = "delete",
	trash_key = "d",
	restore_mode = "delete",
	restore_key = "r",
	trash_list_selector = "fzf -m | cut -d' ' -f3-",
})

require("map").setup()
-- local map = require("map")
-- map.setup{
--   mode = "default"  -- or `xplr.config.modes.builtin.default`,
--   key = "M",
--   editor = os.getenv("EDITOR") or "vim",
--   editor_key = "ctrl-o",
--   prefer_multi_map = false,
--   placeholder = "{}",
--   custom_placeholders = {
--     ["{ext}"] = function(node)
--       -- See https://xplr.dev/en/lua-function-calls#node
--       return node.extension
--     end,
--
--     ["{name}"] = map.placeholders["{name}"]
--   },
-- }
--
-- remap fs operations
-- copy without -v, displaying without a popup shell window - only display logs
-- Silently makes gui not flicker
root_onkey["v"] = {
	help = "copy here",
	messages = {
		{
			BashExecSilently = [===[
              (while IFS= read -r line; do
              if cp -r -- "${line:?}" ./; then
                echo LogSuccess: $line copied to $PWD >> "${XPLR_PIPE_MSG_IN:?}"
              else
                echo LogError: Failed to copy $line to $PWD >> "${XPLR_PIPE_MSG_IN:?}"
              fi
              done < "${XPLR_PIPE_SELECTION_OUT:?}")
              echo ExplorePwdAsync >> "${XPLR_PIPE_MSG_IN:?}"
              echo ClearSelection >> "${XPLR_PIPE_MSG_IN:?}"
              # read -p "[enter to continue]"
            ]===],
		},
		"PopMode",
	},
}

-- move without -v, displaying without a popup shell window - only display logs
-- Silently makes gui not flicker
root_onkey["m"] = {
	help = "move here",
	messages = {
		{
			BashExecSilently = [===[
              (while IFS= read -r line; do
              if mv -- "${line:?}" ./; then
                echo LogSuccess: $line moved to $PWD >> "${XPLR_PIPE_MSG_IN:?}"
              else
                echo LogError: Failed to move $line to $PWD >> "${XPLR_PIPE_MSG_IN:?}"
              fi
              done < "${XPLR_PIPE_SELECTION_OUT:?}")
              echo ExplorePwdAsync >> "${XPLR_PIPE_MSG_IN:?}"
              # read -p "[enter to continue]"
            ]===],
		},
		"PopMode",
	},
}

local action_utils = require("telescope.actions.utils")
local actions = require("telescope.actions")
local uv = vim.loop
local my_utils = require "plugin.telescope.util"
local state = require "telescope.state"
local pickers = require "telescope.pickers"
local action_state = require "telescope.actions.state"
local fb_utils = require "telescope._extensions.file_browser.utils"

local function fp()
  local entry = entry()
  return ("%s/%s"):format(entry.cwd, entry[1])
end

local function dropdown_out(data)
  require "util.fs".write(vim.loop.os_homedir() .. "/tmp/cli", data)
end

local A = {}
function A.close_or_exit(prompt_bufnr, data)
  -- if dropdown, exit nvim
  if CLI then
    -- if prompt_bufnr then actions.close(prompt_bufnr) end
    dropdown_out(data)
    vim.cmd("silent qa!")
  else
    actions.close(prompt_bufnr)
  end
end

function A.move_previewer_window(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)
end

function A.dropdown_exit(prompt_bufnr)
  if not dropdown_profile then vim.api.nvim_err_writeln("not in dropdown profile, doing nothing") return end
  local entry = entry()
  close_or_exit(prompt_bufnr, entry.value)
end

function A.find_files(prompt_bufnr)
  require("telescope.builtin").find_files({ cwd = fp() })
end

function A.live_grep(prompt_bufnr)
  require("telescope.builtin").live_grep({ cwd = fp() })
end

-- function A.create_note(prompt_bufnr)
--   close_or_exit(prompt_bufnr)
--   require("util.fs").create_file_prompt({
--     dest = fp(),
--     ext = "norg",
--   })
-- end

function A.resize(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)
  -- built in layout strats:
  -- horizontal, center, cursor, vertical, flex, bottom_pane
  local height = picker.layout_config.horizontal.height
  picker.layout_config.horizontal.height = height == 0.4 and 0.99 or 0.4
  picker:full_layout_update()
end

function A.close_from_editor()
  pickers.on_close_prompt(my_utils.find_prompt())
end

function A.toggle_focus_picker()
  local prompt_bufnr = my_utils.find_prompt()
  if not prompt_bufnr then return end

  local picker_focused = vim.api.nvim_get_current_buf() == prompt_bufnr
  if picker_focused then
    vim.api.nvim_set_current_win(_G.current_editor_win)
  else
    local picker = action_state.get_current_picker(prompt_bufnr)
    vim.api.nvim_set_current_win(action_state.get_current_picker(prompt_bufnr).prompt_win)
  end
end

local last_win
function A.toggle_focus_previewer()
  local picker = my_utils.find_picker()
  if not picker then return end

  local cwin = vim.api.nvim_get_current_win()
  local previewer_focused = cwin == picker.preview_win
  if previewer_focused then
    return last_win and vim.api.nvim_set_current_win(_G.current_editor_win) or vim.api.nvim_set_current_win(last_win)
  else
    last_win = cwin
    vim.api.nvim_set_current_win(picker.preview_win)
  end
end

-- function A.which_key(prompt_bufnr, opts)
--   -- fix for standard preview - which key errors
--   local picker = action_state.get_current_picker(prompt_bufnr)
--   local old_preview = picker.preview_win
--   picker.preview_win = nil
--   actions.which_key(prompt_bufnr, opts)
--   picker.preview_win = old_preview
-- end

function A.fb_change_depth(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)
  local finder = picker.finder
  local opts = picker.initial_opts
  if not opts.depth then
    opts.depth = 1
  else
    opts.depth = false
  end
  actions.close(prompt_bufnr)
  require "telescope".extensions.file_browser.file_browser(opts)
end

function A.close_or_resume()
local picker = my_utils.find_picker()
-- if vim.tbl_contains({picker.prompt_win, picker.preview_win}, vim.api.nvim_get_current_win()) then
  -- print("telescope selection")
-- end
if picker == nil then
  vim.cmd("Telescope resume")
else
actions.close(picker.prompt_bufnr)
end

end

return A

----

-- all changes implemented into telescope-file-browser fork
local a = vim.api
local Path = require "plenary.path"
local os_sep = Path.path.sep
local truncate = require("plenary.strings").truncate
-- redraws prompt and results border contingent on picker status
require "telescope._extensions.file_browser.utils".redraw_border_title = function(current_picker)
  local finder = current_picker.finder
  if current_picker.prompt_border and not finder.prompt_title then
    local new_title = finder.files and "File Browser" or "Folder Browser"
    current_picker.prompt_border:change_title(new_title)
  end
  if current_picker.results_border and not finder.results_title then
    local new_title
    if finder.files or finder.cwd_to_path then
      -- new_title = finder.path
      new_title = Path:new(finder.path):make_relative(vim.loop.os_homedir())
    else
      new_title = finder.cwd
    end
    local width = math.floor(a.nvim_win_get_width(current_picker.results_win) * 0.8)
    new_title = truncate(new_title ~= os_sep and new_title .. os_sep or new_title, width, nil, -1)
    current_picker.results_border:change_title(new_title)
  end
end


--https://github.com/nvim-telescope/telescope-file-browser.nvim/issues/104#issuecomment-1049647208
--
-- fb_actions.create = function(prompt_bufnr)
--   local current_picker = action_state.get_current_picker(prompt_bufnr)
--   local finder = current_picker.finder
--
--   local default = get_target_dir(finder) .. os_sep
--   vim.ui.input({ prompt = "Insert the file name: ", default = default, completion = "file" }, function(input)
--     vim.cmd [[ redraw ]] -- redraw to clear out vim.ui.prompt to avoid hit-enter prompt
--     local file = create(input, finder)
--     if file then
--       -- values from finder for values don't have trailing os sep for folders
--       local path = file:absolute()
--       path = file:is_dir() and path:sub(1, -2) or path
--       fb_utils.selection_callback(current_picker, path)
--       current_picker:refresh(finder, { reset_prompt = true, multi = current_picker._multi })
--
--     -- added to focus the current file
--  current_picker:register_completion_callback(function()
--       local selection_index = find_entry(current_picker, file.filename)
--       vim.defer_fn(function() current_picker:set_selection(current_picker:get_row(selection_index)) end, 10)
--       local num_cb = #current_picker._completion_callbacks
--       current_picker._completion_callbacks[num_cb] = nil
--     end)
--     end
--   end)
-- end
--




-- local gen_mappings = function(path)
-- local goto_cwd = function(prompt_bufnr)
--   -- because I want goto_cwd to actually goto_path when `cwd_to_path=true`
--   local fb_utils = require "telescope._extensions.file_browser.utils"
--   local current_picker = action_state.get_current_picker(prompt_bufnr)
--   local finder = current_picker.finder
--
--
--
--   dump("asd")
--   if not finder.path == vim.loop.cwd() then
--       finder.path = path and path or vim.loop.cwd()
--   end
--
--   fb_utils.redraw_border_title(current_picker)
--   current_picker:refresh(finder, { reset_prompt = true, multi = current_picker._multi })
-- end
--
-- local attach_mappings = function(_, map)
--       map("i", "<C-w>", goto_cwd)
--       return true
--     end
--
--     return attach_mappings
-- end


-- local on_complete = {
--   function(picker)
--     -- fb_actions.sort_by_date_once(picker.prompt_bufnr)
--     -- picker.clear_completion_callbacks()
--     -- dump("1st")
--     -- dump("1st sort")
--     -- -- 1st completion trigerred when first launched
--     -- picker.clear_completion_callbacks()
--     -- picker.register_completion_callback(function() 
--     --   dump("2nd sort")
--     --   -- 2nd trigerred on first char of prompt
--     --   fb_actions.sort_by_date(picker.prompt_bufnr)
--     -- end)
--   end,
-- }

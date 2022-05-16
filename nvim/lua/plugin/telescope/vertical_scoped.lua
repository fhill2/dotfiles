local resolve = require("telescope.config.resolve")
local p_window = require("telescope.pickers.window")
local if_nil = vim.F.if_nil

local get_border_size = function(opts)
  if opts.window.border == false then
    return 0
  end

  return 1
end

local calc_tabline = function(max_lines)
  local tbln = (vim.o.showtabline == 2) or (vim.o.showtabline == 1 and #vim.api.nvim_list_tabpages() > 1)
  if tbln then
    max_lines = max_lines - 1
  end
  return max_lines, tbln
end

-- Helper function for capping over/undersized width/height, and calculating spacing
--@param cur_size number: size to be capped
--@param max_size any: the maximum size, e.g. max_lines or max_columns
--@param bs number: the size of the border
--@param w_num number: the maximum number of windows of the picker in the given direction
--@param b_num number: the number of border rows/column in the given direction (when border enabled)
--@param s_num number: the number of gaps in the given direction (when border disabled)
local calc_size_and_spacing = function(cur_size, max_size, bs, w_num, b_num, s_num)
  local spacing = s_num * (1 - bs) + b_num * bs
  cur_size = math.min(cur_size, max_size)
  cur_size = math.max(cur_size, w_num + spacing)
  return cur_size, spacing
end

-- return function(self, max_columns, max_lines, layout_config)

--  local initial_options = p_window.get_initial_window_options(self)
--     local preview = initial_options.preview
--     local results = initial_options.results
--     local prompt = initial_options.prompt

--   local win = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
--   local col, row, width, height = win.wincol, win.winrow, win.width, win.height

-- preview.col = col
-- preview.row = row + height - 6
-- preview.width = width
-- preview.height = height - 50

-- results.col = col
-- results.row = row + height - 1
-- results.width = width
-- results.height = 5

-- prompt.col = col
-- prompt.row = 65
-- prompt.width = width
-- prompt.height = 1

-- return {
-- preview = preview,
-- results = results,
-- prompt = prompt,
-- }
-- end
--
--
return function(self, max_columns, max_lines, layout_config)
  local cwin = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
  local layout_config = {}
  layout_config.width = cwin.width
  layout_config.height = cwin.height
  layout_config.preview_cutoff = 40
--local max_columns = cwin.wincol
--local max_lines = cwin.winrow
  self.prompt_prefix = self.prompt_title .. " " .. self.prompt_prefix 
  local initial_options = p_window.get_initial_window_options(self)
  local preview = initial_options.preview
  local results = initial_options.results
  local prompt = initial_options.prompt

  local tbln
  max_lines, tbln = calc_tabline(max_lines)

  local width_opt = layout_config.width
  local width = resolve.resolve_width(width_opt)(self, max_columns, max_lines)

  local height_opt = layout_config.height
  local height = resolve.resolve_height(height_opt)(self, max_columns, max_lines)

   local bs = get_border_size(self)
  -- Cap over/undersized width
  --local height, h_space = calc_size_and_spacing(height, max_lines, bs, 2, 4, 1)
  --local width, w_space = calc_size_and_spacing(width, max_columns, bs, 1, 2, 0)
  prompt.width = width
  results.width = prompt.width
  preview.width = prompt.width

  -- if self.previewer and max_lines >= layout_config.preview_cutoff then
  --   -- Cap over/undersized height (with previewer)
  --   height, h_space = calc_size_and_spacing(height, max_lines, bs, 3, 6, 2)
  --   preview.height = resolve.resolve_height(if_nil(layout_config.preview_height, 0.5))(self, max_columns, height)
  -- else
  --   -- Cap over/undersized height (without previewer)
  --   --height, h_space = calc_size_and_spacing(height, max_lines, bs, 2, 4, 1)
  --   --preview.height = 0
  -- end
  prompt.height = 1
  --results.height = height - preview.height - prompt.height - h_space
  --local height_padding = math.floor((max_lines - height) / 2)
  
  local gconfig = _TelescopeConfigurationValues
  local persist_height = gconfig.layout_config.bottom_pane.height
  local mod = TelescopeGlobalState.persist and persist_height + 4 or 0
  --if not layout_config.mirror then
  --preview.line = max_lines - mod
  --results.line = mod - preview.line + preview.height --+ (1 + bs)
  --prompt.line = mod - results.line + results.height -- + (1 + bs)
  dump("at layout strat")
  dump(self.previewer)
 if self.previewer then
  results.height = 10
  prompt.line = max_lines - mod
  results.line = prompt.line - results.height - 1
  preview.line = 2 
  preview.height = max_lines - mod - prompt.height - results.height

else
  results.height = max_lines - mod - prompt.height
  prompt.line = max_lines - mod + 1
  results.line = max_lines - mod + 3
end

  
  --else
  -- prompt.line = 20 - (height_padding + bs + 1)
  -- results.line = 20 - (prompt.line + prompt.height + (1 + bs))
  -- preview.line = 20 - (results.line + results.height + (1 + bs))
  -- end

  -- if tbln then
  --   prompt.line = prompt.line + 1
  --   results.line = results.line + 1
  --   preview.line = preview.line + 1
  -- end

  results.col, preview.col, prompt.col = cwin.wincol, cwin.wincol, cwin.wincol -- all centered
  return {
    preview = self.previewer and preview.height > 0 and preview,
    results = results,
    prompt = prompt,
  }
end

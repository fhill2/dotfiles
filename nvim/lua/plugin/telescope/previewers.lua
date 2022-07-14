local putils = require "telescope.previewers.utils"
local from_entry = require "telescope.from_entry"
local Previewer = require("telescope.previewers.previewer")
local utils = require "telescope.utils"
local Path = require "plenary.path"
local conf = require("telescope.config").values
local ns_previewer = vim.api.nvim_create_namespace "telescope.previewers"
local buf_delete = utils.buf_delete

local previewers = {}

-- custom functions
function get_editor_win_info()
  local windows = {}
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_get_config(win).relative == "" then
      -- win_config.relative == "" - only non floating windows
      local pos = vim.api.nvim_win_get_position(win)
      table.insert(windows, {
        winnr = win,
        y = pos[1],
        x = pos[2],
      })
    end
  end
  table.sort(windows, function(a, b)
    if a.x ~= b.x then
      return a.x < b.x
    end
    return a.y < b.y
  end)
  return windows
end

function get_editor_wins()
  local wins = {}
  for _, win in ipairs(get_editor_win_info()) do
    table.insert(wins, win.winnr)
  end
  return wins
end

function get_preview_win()

end

local scroll_fn = function(self, direction)
  if not self.state then
    return
  end

  local input = direction > 0 and [[]] or [[]]
  local count = math.abs(direction)

  vim.api.nvim_win_call(self.state.winid, function()
    vim.cmd([[normal! ]] .. count .. input)
  end)
end

local function defaulter(f, default_opts)
  default_opts = default_opts or {}
  return {
    new = function(opts)
      if conf.preview == false and not opts.preview then
        return false
      end
      opts.preview = type(opts.preview) ~= "table" and {} or opts.preview
      if type(conf.preview) == "table" then
        for k, v in pairs(conf.preview) do
          opts.preview[k] = vim.F.if_nil(opts.preview[k], v)
        end
      end
      return f(opts)
    end,
    __call = function()
      local ok, err = pcall(f(default_opts))
      if not ok then
        error(debug.traceback(err))
      end
    end,
  }
end

previewers.vimgrep = defaulter(function(opts)
  opts = opts or {}
  local cwd = opts.cwd or vim.loop.cwd()

  local jump_to_line = function(self, bufnr, lnum)
    pcall(vim.api.nvim_buf_clear_namespace, bufnr, ns_previewer, 0, -1)
    if lnum and lnum > 0 then
      pcall(vim.api.nvim_buf_add_highlight, bufnr, ns_previewer, "TelescopePreviewLine", lnum - 1, 0, -1)
      pcall(vim.api.nvim_win_set_cursor, self.state.winid, { lnum, 0 })
      vim.api.nvim_buf_call(bufnr, function()
        vim.cmd "norm! zz"
      end)
    end
  end

  return previewers.new_nonfloat_buffer_previewer {
    title = "Grep Preview",
    dyn_title = function(_, entry)
      return Path:new(from_entry.path(entry, true)):normalize(cwd)
    end,

    get_buffer_by_name = function(_, entry)
      return from_entry.path(entry, true)
    end,

    define_preview = function(self, entry, status)
      local p = from_entry.path(entry, true)
      if p == nil or p == "" then
        return
      end

      -- Workaround for unnamed buffer when using builtin.buffer
      if entry.bufnr and (p == "[No Name]" or vim.api.nvim_buf_get_option(entry.bufnr, "buftype") ~= "") then
        local lines = vim.api.nvim_buf_get_lines(entry.bufnr, 0, -1, false)
        vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
        jump_to_line(self, self.state.bufnr, entry.lnum)
      else
        conf.buffer_previewer_maker(p, self.state.bufnr, {
          bufname = self.state.bufname,
          winid = self.state.winid,
          preview = opts.preview,
          callback = function(bufnr)
            jump_to_line(self, bufnr, entry.lnum)
          end,
        })
      end
    end,
  }
end, {})

previewers.cat = defaulter(function(opts)
  -- default previewer for find_files etc
  opts = opts or {}
  dump("previewers cat")
  dump(opts)
  local cwd = opts.cwd or vim.loop.cwd()
  return previewers.new_nonfloat_buffer_previewer {
    title = "File Preview",
    dyn_title = function(_, entry)
      return Path:new(from_entry.path(entry, true)):normalize(cwd)
    end,

    get_buffer_by_name = function(_, entry)
      return from_entry.path(entry, true)
    end,

    define_preview = function(self, entry, status)
      local p = from_entry.path(entry, true)
      if p == nil or p == "" then
        return
      end
      conf.buffer_previewer_maker(p, self.state.bufnr, {
        bufname = self.state.bufname,
        winid = self.state.winid,
        preview = opts.preview,
      })
    end,
  }
end, {})




-- previewers/buffer_previewer.lua - 273
previewers.new_nonfloat_buffer_previewer = function(opts)
  opts = opts or {}
  -- EDIT
  -- so the corresponding layout strat can identify this previewer
  opts.title = "nonFloat Previewer"

  assert(opts.define_preview, "define_preview is a required function")
  assert(not opts.preview_fn, "preview_fn not allowed")

  local opt_setup = opts.setup
  local opt_teardown = opts.teardown
  -- EDIT

  local old_bufs = {}
  local bufname_table = {}

  local global_state = require "telescope.state"
  local preview_window_id

  local function get_bufnr(self)
    if not self.state then
      return nil
    end
    return self.state.bufnr
  end

  local function set_bufnr(self, value)
    if self.state then
      self.state.bufnr = value
      table.insert(old_bufs, value)
    end
  end

  local function get_bufnr_by_bufname(self, value)
    if not self.state then
      return nil
    end
    return bufname_table[value]
  end

  local function set_bufname(self, value)
    if self.state then
      self.state.bufname = value
      if value then
        bufname_table[value] = get_bufnr(self)
      end
    end
  end

  function opts.setup(self)
    dump("AT SETUP")
    dump(self)
    local state = {}
    --local editor_wins = get_editor_wins()
    local initial_editor_wins = get_editor_wins()
    if #initial_editor_wins <= 1 then
      vim.api.nvim_buf_call(vim.api.nvim_win_get_buf(initial_editor_wins[1]), function()
        vim.cmd("vert sbuffer")
      end)
      local editor_wins = get_editor_wins()
      preview_win_id = editor_wins[#editor_wins]
    end

    if opt_setup then
      vim.tbl_deep_extend("force", state, opt_setup(self))
    end
    return state
  end

  function opts.teardown(self)
    if opt_teardown then
      opt_teardown(self)
    end

    local last_nr
    if opts.keep_last_buf then
      last_nr = global_state.get_global_key "last_preview_bufnr"
      -- Push in another buffer so the last one will not be cleaned up
      if preview_window_id then
        local bufnr = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_win_set_buf(preview_window_id, bufnr)
      end
    end

    set_bufnr(self, nil)
    set_bufname(self, nil)

    for _, bufnr in ipairs(old_bufs) do
      if bufnr ~= last_nr then
        buf_delete(bufnr)
      end
    end
    -- enable resuming picker with existing previewer to avoid lookup of deleted bufs
    bufname_table = {}
  end

  opts.preview_fn = function(self, entry, status)
    dump(preview_win_id)
    dump("my previewer: preview_fn")
    if get_bufnr(self) == nil then
      -- EDIT
      set_bufnr(self, vim.api.nvim_win_get_buf(preview_win_id))
    end

    if opts.get_buffer_by_name and get_bufnr_by_bufname(self, opts.get_buffer_by_name(self, entry)) then
      self.state.bufname = opts.get_buffer_by_name(self, entry)
      self.state.bufnr = get_bufnr_by_bufname(self, self.state.bufname)
      vim.api.nvim_win_set_buf(status.preview_win, self.state.bufnr)
    else
      local bufnr = vim.api.nvim_create_buf(false, true)
      set_bufnr(self, bufnr)

      vim.schedule(function()
        if vim.api.nvim_buf_is_valid(bufnr) then
          -- EDIT
          vim.api.nvim_win_set_buf(preview_win_id, bufnr)
        end
      end)

      vim.api.nvim_win_set_option(status.preview_win, "winhl", "Normal:TelescopePreviewNormal")
      vim.api.nvim_win_set_option(status.preview_win, "signcolumn", "no")
      vim.api.nvim_win_set_option(status.preview_win, "foldlevel", 100)
      vim.api.nvim_win_set_option(status.preview_win, "wrap", false)
      vim.api.nvim_win_set_option(status.preview_win, "scrollbind", false)

      self.state.winid = status.preview_win
      self.state.bufname = nil
    end

    if opts.keep_last_buf then
      global_state.set_global_key("last_preview_bufnr", self.state.bufnr)
    end

    opts.define_preview(self, entry, status)

    putils.with_preview_window(status, nil, function()
      vim.cmd "do User TelescopePreviewerLoaded"
    end)

    if opts.get_buffer_by_name then
      set_bufname(self, opts.get_buffer_by_name(self, entry))
    end
  end

  if not opts.scroll_fn then
    opts.scroll_fn = scroll_fn
  end

  return Previewer:new(opts)
end




return previewers




-- function get_editor_wins()
--   local c_tabinfo = vim.fn.gettabinfo()[1]
--   local windows = {}
--   --dump(vim.api.nvim_tabpage_list_wins(0))
--   for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
--     local win_config = vim.api.nvim_win_get_config(win)
--     --dump(win_config)
--     local buf_ft = vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(win), "filetype")
--     --dump(buf_ft)
--     if win_config.relative == "" and not vim.tbl_contains(_G.f.non_editor_filetypes, buf_ft) then
--       -- win_config.relative == "" - only non floating windows
--       table.insert(windows, win)
--     end
--   end
--   --dump("GET EDITOR WIN COUNT", windows)
--   return windows
-- end

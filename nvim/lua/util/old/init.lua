local parser = require("util.old.parser")
local nui = require("plugin.nui.popup")
local uv = vim.loop
local fs = require"util.fs"
local M = {}

function M.parse(cfp)
  local cft = vim.bo.filetype

  -- format:
  -- [1] = current filepath is checked to see if it contains each set strings under config.filetype[language] & all. all substrings must match to equal a final match.
  -- [2] = if a set of strings are matched, transform() callback generates destination path. if no callback, will split at the match found furthest to the end

  local config = {}

  config.filetype = {
    lua = {
      { { "me-plug" } },
      { { "fork-plug" } },
    },
    vim = {},
    shell = {
      { { "me-plug" } },
    },
  }

  config.all = {
    {
      { "dot" },
      transform = function(old)
        return old.cfp:gsub("/dot/", "/dev/cl/old/dot/")
      end,
    },
    {
      { f.dev_cl .. "/lua/standalone" },
      transform = function(old)
        dump(old)
        return old.cfp:gsub("cl/lua", "cl/old/lua")
      end
    },
  {
    { f.dev_cl .. "/shell" },
      transform = function(old)
        dump(old)
        return old.cfp:gsub("cl/shell", "cl/old/shell")
      end
    }
  }

  return parser.parse(config, cfp, cft)
end


--local function show_gui(old_path)
--vim.defer_fn(function()
    --nui.open({ name = "send_to_old", action = "open_file", action_args = { pos = "btm" }, filepath = old_path })
--end, 50)
--end

function M.show(old_path)
--local cfp = vim.fn.expand("%:p")
--local old_path = M.parse(cfp)
--show_gui(old_path)
nui.popup({ name = "old", fp = old_path })
end

M.test = function() M.send({ dry = true}) end



M.send = vim.schedule_wrap(function(opts)
  opts = opts or {}
  local cfp = vim.fn.resolve(vim.fn.expand("%:p"))

  if opts.dry then 
    print("DRY:")
    print('current fp: ' .. cfp)
  end
  local filename = vim.fn.expand("%:t")
  local old_path = M.parse(cfp)
  if opts.dry then print("old_path: " .. old_path) return end
  require"util.fs".create_fp_dirs(old_path)

  local old_file_exists = uv.fs_stat(old_path)
  if opts.whole and not old_file_exists then
    uv.fs_rename(cfp, old_path, function()
    end)
  elseif opts.whole and old_file_exists then
    print("File already exists in old - appending to and deleting source")
    f.append_to_file(old_path, "\n\n" .. table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, true), "\n"))
    uv.fs_rename(cfp, f.home .. "/.local/share/Trash/files/" .. filename, function()
    end)
  elseif not opts.whole then
    local visual = f.get_visual({lines=true})
    f.append_to_file(old_path, "\n\n" .. table.concat(visual, "\n"))
  end

  
  if opts.whole then
  vim.cmd("Bdelete! " .. vim.api.nvim_get_current_buf())
else
  local range = f.get_visual({range=true, lines=true})
  vim.api.nvim_buf_set_lines(vim.api.nvim_get_current_buf(), range.start_row - 1, range.end_row, false, {})
  M.show(old_path)
end
end)

return M

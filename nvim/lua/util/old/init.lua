-- local parser = require("util.old.parser")
local nui = require("plugin.nui.popup")
local uv = vim.loop
local fs = require "util.fs"
local Path = require"plenary.path"
local os_sep = Path.path.sep

local M = {}

function M.show(old_path)
  --local cfp = vim.fn.expand("%:p")
  --local old_path = M.parse(cfp)
  --show_gui(old_path)
  nui.popup({ name = "old", fp = old_path })
end

M.test = function() M.send({ dry = true }) end

local parse = function(fp)
 return vim.loop.os_homedir() .. os_sep .. "old" .. os_sep .. Path:new(fp):make_relative(vim.loop.os_homedir())
end

M.send_whole = function()
M.send({whole = true})
end

M.send = vim.schedule_wrap(function(opts)
  opts = opts or {}
  local cfp = vim.fn.resolve(vim.fn.expand("%:p"))

  local filename = vim.fn.expand("%:t")
  local old_path = parse(cfp)

  if opts.dry then 
    vim.notify({ ("cfp: %s"):format(cfp), ("old_path: %s"):format(old_path) }, "info" )
    return
  end


  require "util.fs".create_fp_dirs(old_path)

  local old_file_exists = uv.fs_stat(old_path)
  if opts.whole and not old_file_exists then
    uv.fs_rename(cfp, old_path, function()
    end)
  elseif opts.whole and old_file_exists then
    vim.notify({"Deleting source...", ("Appending to: "):format(old_path)})
    f.append_to_file(old_path, "\n\n" .. table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, true), "\n"))
    uv.fs_rename(cfp, f.home .. "/.local/share/Trash/files/" .. filename, function()
    end)
  elseif not opts.whole then
    local visual = f.get_visual({ lines = true })
    f.append_to_file(old_path, "\n\n" .. table.concat(visual, "\n"))
  end


  if opts.whole then
    vim.cmd("Bdelete! " .. vim.api.nvim_get_current_buf())
  else
    local range = f.get_visual({ range = true, lines = true })
    vim.api.nvim_buf_set_lines(vim.api.nvim_get_current_buf(), range.start_row - 1, range.end_row, false, {})
    M.show(old_path)
  end
end)

return M






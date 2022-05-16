local M = {}

local Popup = require("nui.popup")

--local manager = {}

M.popup = vim.schedule_wrap(function(opts)
  if not manager then
    manager = {}
  end
  local opts = opts or {}

  if opts.close then
    for _, popup in pairs(manager) do
      popup:unmount()
    end
    manager = {}
    return
  end

  --if not opts.title then opts.title = vim.api.nvim_buf_get_name() end
  if not opts.fp or not opts.name then
    vim.api.nvim_err_writeln("opts.fp and opts.name needed")
    return
  end

  if not opts.title then
    opts.title = opts.fp
  end

  local popup = manager[opts.name]
  if not manager[opts.name] then
    popup = Popup({
      size = { height = "25%", width = "75%" },
      position = { row = "99%", col = "40%" },
      relative = "win",
      border = {
        style = "single",
        text = {
          top = " " .. opts.title .. " ",

          top_align = "center",
        },
      },
    })

    popup:mount()
    manager[opts.name] = popup
  end

  vim.api.nvim_buf_call(popup.bufnr, function()
    vim.cmd("e " .. opts.fp)
    vim.cmd("normal G")
  end)

  -- M.open_file({
  --   filepath = opts.fp,
  --   bufnr = popup.bufnr,
  --   winnr = popup.winid,
  -- })
end)

-- M.close_all_windows = function()
--   M.popup({ close = true })
--   --dump(manager)
--   --for name, popup in ipairs(manager) do
--   --popup:unmount()
--   --end
--   --manager = {}
-- end

function M.open_file(opts)
  -- because :e filepath makes which key show
  if not opts.filepath then
    vim.api.nvim_buf_set_lines(opts.bufnr, 0, -1, false, { "Error: filepath not specified" })
    return
  end

  -- dont do anything if buffer already contains the file
  local cfp = vim.fn.expand("%")
  if cfp == opts.filepath then
    print("open file: buffer already contains file")
    return
  end

  local buf_loaded = false
  -- if buffer already exists in neovim but not in window
  for k, bufnr in pairs(vim.api.nvim_list_bufs()) do
    local iter_name = vim.api.nvim_buf_get_name(bufnr)
    if iter_name == opts.filepath then
      vim.api.nvim_buf_set_option(bufnr, "buflisted", true)
      vim.api.nvim_win_set_buf(opts.winnr, bufnr)
      opts.bufnr = bufnr
      buf_loaded = true
      return
    end
  end

  --vim.api.nvim_buf_set_name(opts.bufnr, opts.filepath)
  --vim.api.nvim_buf_set_option(opts.bufnr, "buftype", "")
  --vim.schedule(function() vim.api.nvim_buf_call(opts.bufnr, function() vim.cmd([[edit!]]) end) end)
  --vim.cmd('e!')
  if not buf_loaded then
  end

  vim.cmd("normal G")
end

return M

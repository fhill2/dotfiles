local M = {}
local Input = require("nui.input")
local event = require("nui.utils.autocmd").event
----
M.prompt = vim.schedule_wrap(function(opts)
  local input = Input({
    position = "20%",
    size = {
      width = vim.api.nvim_win_get_width(0) - 2,
      height = 2,
    },
    relative = "editor",
    border = {
      style = "single",
      text = {
        top = " " .. opts.title .. " ",

        top_align = "center",
      },
    },
  }, {
    prompt = "> ",
    on_submit = opts.on_submit,
  })
  input:mount()
 
  -- unmount component when cursor leaves buffer
  input:on(event.BufLeave, function()
    input:unmount()
  end)

  vim.api.nvim_buf_call(input.bufnr, function()
    vim.cmd("startinsert")
  end)
  return input
end)

return M

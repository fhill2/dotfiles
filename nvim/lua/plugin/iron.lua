--- iron config


local iron = require("iron")
local view = require('iron/view')


iron.core.set_config{
  -- your configuration goes here
repl_open_cmd = view.openwin('sp')
}




--- 

local iron = {}

function iron.send_whole_file()
  require("iron").core.send(vim.bo.ft, vim.fn.readfile(vim.fn.expand("%")))
end

function iron.send_whole_file_2()
require("iron").core.send(vim.api.nvim_buf_get_option(0,"ft"), vim.api.nvim_buf_get_lines(0, 0, -1, false))
end

return iron




-- this method adds plugin defined nvim-dap configuration entries to use when require'dap'.continue() is executed
-- default configurations are: launch file, launch file with arguments, attach remote
-- note if dap-python isnt working on a new install, check if debugpy python lib is installed in the python site packages of the python bin passed into dap-python setup() below
local dap = require("dap")
local dapui = require("dapui")
local dap_python = require("dap-python")
dap_python.setup("/usr/bin/python")

dap.listeners.after["event_initialized"]["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before["event_terminated"]["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before["event_exited"]["dapui_config"] = function()
	dapui.close()
end
dapui.setup()

-- good config setup here
--https://github.com/mfussenegger/nvim-dap/issues/459

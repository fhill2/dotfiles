local packer = require "packer"
packer.init({
  package_root = vim.loop.os_homedir() .. "/tmp",
  plugin_package = "nvim-dropdown",
  compile_path = vim.loop.os_homedir() .. "/dot/nvim-dropdown/plugin/packer_dropdown_compiled.lua"
})
packer.reset()
require "plugins-shared"

vim.cmd "colorscheme material"
vim.cmd "set laststatus=0"

local packer = require "packer"
packer.init({
  package_root = vim.loop.os_homedir() .. "/tmp",
  plugin_package = "nvim-test",
  compile_path = vim.loop.os_homedir() .. "/dot/nvim-test/plugin/packer_test_compiled.lua"
})
packer.reset()
-- plugins here, or require parts of config from nvim-test/lua

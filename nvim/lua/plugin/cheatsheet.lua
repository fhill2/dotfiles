-- <leader>? to openmatically uses Telescope if in
-- path to personal cheatsheet
-- ~/.config/nvim/cheatsheet.txt

-- C-E - edit user cheatsheet
-- C-Y yank cheatcode
-- fill in the command line
--https://github.com/sudormrfbin/cheatsheet.nvim/issues/7

require("cheatsheet").setup({
  -- Whether to show bundled cheatsheets

  -- For generic cheatsheets like default, unicode, nerd-fonts, etc
  bundled_cheatsheets = {
    --enabled = {},
    disabled = { "nerd-fonts" },
  },


  -- For plugin specific cheatsheets
  -- bundled_plugin_cheatsheets = {
  --     enabled = {},
  --     disabled = {},
  -- }
  bundled_plugin_cheatsheets = true,

  -- For bundled plugin cheatsheets, do not show a sheet if you
  -- don't have the plugin installed (searches runtimepath for
  -- same directory name)
  include_only_installed_plugins = true,

  -- Key mappings bound inside the telescope window
  telescope_mappings = {
    ['<CR>'] = require('cheatsheet.telescope.actions').select_or_fill_commandline,
    ['<A-CR>'] = require('cheatsheet.telescope.actions').select_or_execute,
    ['<C-Y>'] = require('cheatsheet.telescope.actions').copy_cheat_value,
    ['<C-E>'] = require('cheatsheet.telescope.actions').edit_user_cheatsheet,
  }
})

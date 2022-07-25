require('legendary').setup({
  -- Include builtins by default, set to false to disable
  include_builtin = false,
  -- Include the commands that legendary.nvim creates itself
  -- in the legend by default, set to false to disable
  include_legendary_cmds = true,
  -- Customize the prompt that appears on your vim.ui.select() handler
  -- Can be a string or a function that takes the `kind` and returns
  -- a string. See "Item Kinds" below for details. By default,
  -- prompt is 'Legendary' when searching all items,
  -- 'Legendary Keymaps' when searching keymaps,
  -- 'Legendary Commands' when searching commands,
  -- and 'Legendary Autocmds' when searching autocmds.
  select_prompt = nil,
  -- Optionally pass a custom formatter function. This function
  -- receives the item as a parameter and must return a table of
  -- non-nil string values for display. It must return the same
  -- number of values for each item to work correctly.
  -- The values will be used as column values when formatted.
  -- See function `get_default_format_values(item)` in
  -- `lua/legendary/formatter.lua` to see default implementation.
  formatter = nil,
  -- When you trigger an item via legendary.nvim,
  -- show it at the top next time you use legendary.nvim
  most_recent_item_at_top = true,
  -- Initial keymaps to bind
  keymaps = {
    { '<leader>c', _G.paste_code_with_md_code_block, description = "discord copy", mode = { 'v' }}
    -- your keymap tables here
  },
  -- Initial commands to bind
  commands = {
     { ':FOldTest', require("util.old.init").test, description = 'old - dry run - print output paths' },
     { ':FOldWhole', require("util.old.init").send_whole, description = 'old - send whole file' },
     { ':FParserUnlock', require("util.run.init").unlock_parser, description = 'run - unlock parser' },
     { ':FParserLock', require("util.run.init").lock_parser, description = 'run - lock parser - default no ft raw output', { "default" } },
     { ':FSnipRunReplToggle', require"plugin.sniprun.repl".toggle, description = 'sniprun REPL toggle' }, 
     { ':FformatGithubReposDotbot', _G.format_github_repos_dotbot, description = 'dotbot - format github repos' }, 
    -- your command tables here
  },
  -- Initial augroups and autocmds to bind
  autocmds = {
    -- your autocmd tables here
  },
  which_key = {
    -- you can put which-key.nvim tables here,
    -- or alternatively have them auto-register,
    -- see section on which-key integration
    mappings = {},
    opts = {},
    -- controls whether legendary.nvim actually binds they keymaps,
    -- or if you want to let which-key.nvim handle the bindings.
    -- if not passed, true by default
    do_binding = {},
  },
  -- Automatically add which-key tables to legendary
  -- see "which-key.nvim Integration" below for more details
  auto_register_which_key = false,
  -- settings for the :LegendaryScratch command
  scratchpad = {
    -- configure how to show results of evaluated Lua code,
    -- either 'print' or 'float'
    -- Pressing q or <ESC> will close the float
    display_results = 'float',
  },
})


local legendary = {}

legendary.find_by_desc = function(term)
  require('legendary').find(nil,
    function(item)
      if not string.find(item.kind, 'keymap') then
        return true
      end
      dump(item)
      return vim.startswith(item.description, term)
    end
  )

end


return legendary

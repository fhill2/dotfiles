local tui_snippets = {}

local log = require'log1'

local actions = require'telescope.actions'
local actions_set = require'telescope.actions.set'
local conf = require'telescope.config'.values
local entry_display = require'telescope.pickers.entry_display'
local finders = require'telescope.finders'
local from_entry = require'telescope.from_entry'
local pickers = require'telescope.pickers'
local previewers = require'telescope.previewers.term_previewer'
local utils = require'telescope.utils'
local Path = require('plenary.path')

local os_home = vim.loop.os_homedir()



local function entry_maker(opts)
  local displayer = entry_display.create{
    separator = ' ',
    items = {
      {width = 75, left_justify = true}, -- body
      {remaining = true}, -- desc
    },
  }


  local function make_display(entry)
  return displayer{
    { entry.value, 'TelescopeResultsIdentifier'},
      entry.desc,
  }
  end

  return function(line)
  
local body = line:match'^(.*):::::'
local desc = line:match':::::(.*)$'
log.info(body)
log.info(desc)
--log.info(line)

return {
    value = body,
    desc = desc,
    ordinal = body .. desc,
    display = make_display
    }

  end

end

tui_snippets.show = function(opts)



  opts = opts or {}

  opts.cmd = {vim.o.shell, '-c', './get_snippets.zsh'}
  opts.cwd = '~/cl/snippets'

  pickers.new(opts, {
    prompt_title = 'TUI Snippets',
    finder = finders.new_table{
      results = utils.get_os_command_output(opts.cmd, opts.cwd),
      entry_maker = entry_maker(),
    },
 }):find()




end


return tui_snippets

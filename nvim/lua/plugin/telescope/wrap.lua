-- [WIP]
-- extension wrapper
local find_frecency = require "plugin.telescope.find_frecency"
-- local notes_cwd = "/home/f1/dev/notes"
local home = vim.loop.os_homedir()
local utils = require "plugin.telescope.util"
local fb_actions = require "telescope".extensions.file_browser.actions
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"

local wrap = {}

local fb = function(opts)
  require "telescope".extensions.file_browser.file_browser(opts)
end

local merge = function(defaults, opts)  
    return opts and vim.tbl_deep_extend("force", defaults, opts) or defaults
end

function wrap.fb(opts)
  fb(merge({ cwd_to_path = false}, opts))
end


function wrap.fb_cbuf()
  fb({
    path = vim.fn.expand("%:p:h"),
    select_buffer = true
  })
end

function wrap.fb_dot()
  path = home .. "/dot"
  fb{
    path = path,
    initial_sort = true,
  }
end

function wrap.fb_cwd()
  fb{} -- cwd_to_path = true
end

function wrap.fb_dev()
  local path = home .. "/dev"
  fb{
    path = path,
    -- attach_mappings = gen_mappings(path),
  }
end

function wrap.fb_home()
  local path = home
  fb{
    path = path,
    -- attach_mappings = gen_mappings(path),
  }
end

function wrap.fb_repos()
  local path = home .. "/repos-flat"
  fb{
    path = path,
    -- depth = 1,
    -- attach_mappings = gen_mappings(path),
  }
end


function wrap.fb_notes()
  local path = home .. "/dev/notes/linux"
  fb{
    path = path,
    initial_sort = true
  }
end
function wrap.fb_notes_tags()
  local path = home .. "/notes-tags"
  fb{
    path = path,
    -- initial_sort = true
  }
end

-- function wrap.ff_dirs_repos()
--   wrap.ff_dirs({ show_repos = true })
-- end
--
-- function wrap.ff_files_repos()
--   wrap.ff_files({ show_repos = true })
-- end
--
-- function wrap.ff_dirs(opts)
--   -- dirs only
--   local opts = opts or {}
--   opts.dirs_only = true
--   find_frecency.show(opts)
-- end
--
-- function wrap.ff_files(opts)
--   local opts = opts or {}
--   opts.mtime = false
--   opts.show_dirs = false
--   find_frecency.show(opts)
-- end


return wrap

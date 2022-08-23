-- [WIP]
-- extension wrapper
-- local notes_cwd = "/home/f1/dev/notes"
local home = vim.loop.os_homedir()
-- local utils = require "plugin.telescope.util"
local fb_actions = require "telescope".extensions.file_browser.actions
local actions = require "telescope.actions"
-- local action_state = require "telescope.actions.state"
local wrap = {}


-- why? I can't find a way to for telescope-file-browser extension only
-- _TelescopeFileBrowserConfig = require "telescope".extensions.file_browser.config.values
-- _TelescopeFileBrowserConfig = require "telescope._extensions.file_browser.config".values
--  
-- local defaults = {
--
-- attach_mappings = function(_, map)
--     _TelescopeFileBrowserConfig.attach_mappings(_, map)
--       return false
--     end,
--
-- }
--
local fb = function(opts)
  -- require "telescope".extensions.file_browser.file_browser(vim.tbl_deep_extend("keep", opts, defaults))
  require "telescope".extensions.file_browser.file_browser(opts)
end

-- local merge = function(defaults, opts)  
--     return opts and vim.tbl_deep_extend("force", defaults, opts) or defaults
-- end

function wrap.fb(opts)
  -- fb(merge({ cwd_to_path = false}, opts))
  fb{cwd_to_path = false}
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
  local path = _G.telescope_fb_repo_resolver(function() 
    return _G.fb_current_dir end)
  fb{ path = path}
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

function wrap.fb_repos_flat()
  local path = home .. "/repos-flat"
  fb{path = path }
end
function wrap.fb_repos_tags()
  local path = home .. "/repos-tags"
  fb{path = path }
end

function wrap.fb_old()
  local old_path = require"util.old".get_old_path()
  while not vim.loop.fs_stat(old_path.filename) do
    old_path = old_path:parent()
  end

  fb{
    path = old_path.filename
  }
end


function wrap.fb_notes()
  local path = home .. "/dev/notes"
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

return wrap

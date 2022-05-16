

--local load = {}

--load.f = function()
profile_main = load_profile and true or false
_G.f = {}
-- TODO add fs_stat to this
_G.f.home = vim.loop.os_homedir()
_G.f.cl = _G.f.home .. "/cl"

_G.f.dev = _G.f.home .. "/dev"
_G.f.dev_cl = _G.f.dev .. "/cl"
_G.f.old = _G.f.dev_cl .. "/old"
_G.f.dot = _G.f.home .. "/dot"
require('globals/init')
require"opts"

-- sniprun.lua is installed from the AUR
--require"plugin.sniprun.setup"

  vim.defer_fn(function()
  require("plugins")
end, 0)
--end


--[[ load.g = function() end


load.dropdown = function() 
  print("DROPDOWN CALLED")
end ]]

--[[ local mt = {}
mt.__index = function() 
  print("INDEX CALLED")
  -- default
  load.f()
end ]]
--setmetatable(load, mt)
--load[load_profile or "f"]()

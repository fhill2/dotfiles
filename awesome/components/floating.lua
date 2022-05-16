local awful = require("awful")
local gears = require"gears"

local M = {}

local floaters = {
  --kittybtm = {}
}




function M.raise_spawn_toggle(opts)
  log("---- F3 trig! --- ")

  local c = floaters[opts.name]
  local send = ("kitty @ --to unix://tmp/%s"):format(opts.name)

local function run_cmds(cmds)
local cmds = type(cmds) == "string" and {cmds} or cmds
for i, cmd in ipairs(cmds) do
cmds[i] = ("%s %s"):format(send, cmds[i])
end
run(cmds)
end

 

    if not c or not c.valid then
    local cmd = {"kitty", "-T", opts.name, "--listen-on", ("unix:/tmp/%s"):format(opts.name) } 
    if opts.cwd then 
    table.insert(cmd, "-d")
    table.insert(cmd, opts.cwd)
    end
   
    table.insert(cmd, opts.cmd)

    awful.spawn.single_instance(
      cmd,
      {
        floating = true,
        placement = awful.placement.bottom
      },
      _,
      _,
      function(c)
        floaters[opts.name] = c
        if opts.on_open then opts.on_open(c) end
        if opts.on_open_cmds then run_cmds(opts.on_open_cmds) end
      end
    )

   
  end


 
  
  if c and c.valid and c.minimized == true then
    c.minimized = false
    if opts.on_maximize_cmds then run_cmds(opts.on_maximize_cmds) end
  elseif c and c.valid then
    c.minimized = true
    c:raise()
    if opts.on_minimize then opts.on_minimize() end
    if opts.on_minimize_cmds then run_cmds(opts.on_minimize_cmds) end
   
 end



end

return M

-- local Floating = {}

-- Floating.__index = Floating

-- function Floating:new()
-- -- you have to add callback because awesome only returns to variable after 2nd keypress
-- log('floating new called')
-- local client = awful.spawn.raise_or_spawn("kitty -T kittybtm", {
--     floating  = true,
--     --tag       = awful.mouse.screen.selected_tag,
--     placement = awful.placement.bottom_right,
--   }, _, _, function(c) client = c end)

-- return {
--  client = client
-- }
-- end

-- function Floating:toggle()
-- log('floating toggle called')
-- end

-- return Floating
--
--
--    --    local floating
-- if not floating then
--   floating = Floating:new()
-- else
--   floating:toggle()
-- end

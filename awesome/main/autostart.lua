local awful = require "awful"

local M = {}

M.setup = function()
autorun = true
autorunApps = 
{ 
   "/home/f1/dev/dot/home-manager/config/awesome/main/autostart.sh",
}
if autorun then
   for app = 1, #autorunApps do
       awful.util.spawn(autorunApps[app])
   end
end
end

return M

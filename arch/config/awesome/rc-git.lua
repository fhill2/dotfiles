--require"globals"
require('default')
package.path = package.path .. ";/home/f1/dev/cl/lua/standalone/?.lua;"

local awful = require('awful')

--local dynamite = require"dynamite"

-- ELIVANIAVA KEYMAP --
pcall(require, "luarocks.loader")
require("beautiful").init(
  os.getenv "HOME" .. "/.config/awesome/themes/main/theme.lua"
)
require "awful.autofocus"

local gears = require "gears"
local menubar = require "menubar"
local bind_to_tags = require "keybinds.bindtotags"
local globalkeys = require "keybinds.globalkeys"

local terminal = require("main.variables").terminal
menubar.utils.terminal = terminal

root.keys(bind_to_tags(globalkeys))

--require("main.error-handling").setup()
--require("main.signals").setup()
--require("main.titlebar").setup()
--require("main.volume-widget").setup()
--require("main.tags").setup()
require("main.autostart").setup()
require("main.rules").setup()
--require("statusbar").setup()




--- MY OWN ----

-- local beautiful = require'beautiful'
-- beautiful.init(
--   os.getenv "HOME" .. "/.config/awesome/themes/main/theme.lua"
-- )


require'awful.remote'


--require'main.autostart'.setup()

--log('awesomewm startup')

-- awful.keyboard.append_global_keybindings({ awful.key({}, "F2", function (c) 
-- log('F2 key fired')
-- awful.util.spawn("rofi -modi drun -show drun -show-icons -width 22 -no-click-to-exit", false)
-- end, {description = "app launcher", group = "global" })})



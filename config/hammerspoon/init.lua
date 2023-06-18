-- find spoons under ~/.config/hammerspoon by adding to package.path
-- https://github.com/Hammerspoon/hammerspoon/blob/master/SPOONS.md
package.path = package.path .. ";" .. hs.configdir .. "/myspoons/?.spoon/init.lua"
print("======== LOADING HAMMERSPOON INIT.lua ========")
print(package.path)

stackline = require("stackline")
stackline:init()

-- local events = hs.eventtap.event.types
-- keyboardTracker = hs.eventtap.new({ events.keyUp }, function(e)
--   local keyCode = e:getKeyCode()
--   hs.alert.show(keyCode) -- for debugging only
-- end)
-- keyboardTracker:start()

-- debugging
-- require("debugging")

-- hs.loadSpoon("RecursiveBinder")

hs.loadSpoon("SpoonInstall")


-- define actions to be shared between hyper key and command list


-- RecursiveBinder config
local RecursiveBinder = hs.loadSpoon("RecursiveBinder")
RecursiveBinder.escapeKey = { {}, "escape" } -- Press escape to abort

local singleKey = RecursiveBinder.singleKey

RecursiveBinder.keymaps = {
  [singleKey("b", "browser")] = function()
    hs.application.launchOrFocus("Firefox")
  end,
  [singleKey("t", "terminal")] = function()
    hs.application.launchOrFocus("Terminal")
  end,
  [singleKey("d", "domain+")] = {
    [singleKey("g", "github")] = function()
      hs.urlevent.openURL("https://github.com")
    end,
    [singleKey("y", "youtube")] = function()
      hs.urlevent.openURL("https://youtube.com")
    end,
  },
}



spoon.SpoonInstall:andUse("ControlEscape", {})
spoon.Seal:loadPlugins({"useractions"})
spoon.Seal.plugins.useractions.actions =
   {
      ["Hammerspoon docs webpage"] = {
         url = "http://hammerspoon.org/docs/",
         icon = hs.image.imageFromName(hs.image.systemImageNames.ApplicationIcon),
         description = "Open Hammerspoon documentation",
         hotkey = { hyper, "h" },
      },
      ["Leave corpnet"] = {
         fn = function()
            spoon.WiFiTransitions:processTransition('foo', 'corpnet01')
         end,
      },
      ["Arrive in corpnet"] = {
         fn = function()
            spoon.WiFiTransitions:processTransition('corpnet01', 'foo')
         end,
      },
      ["Translate using Leo"] = {
         url = "http://dict.leo.org/ende/index_de.html#/search=${query}",
         icon = 'favicon',
         keyword = "leo",
      },
      ["Tell me something"] = {
         keyword = "tellme",
         fn = function(str) hs.alert.show(str) end,
      }

-- recursiveBinder.recursiveBind(keyMap)

-- hyper_on_press = function()
--   print("f18 pressed")
--   RecursiveBinder.showHelper()
-- end
-- hyper_on_release = function()
--   print("f18 released")
--   RecursiveBinder.killHelper()
-- end
-- hs.hotkey.bind({}, "F18", hyper_on_press, hyper_on_release)
-- hs.hotkey.bind({}, "f18", RecursiveBinder.recursiveBind(keyMap))
-- end,
-- })

--  https://github.com/dbalatero/HyperKey.spoon
-- Load and create a new switcher
-- local HyperKey = hs.loadSpoon("HyperKey")
-- hk = HyperKey:new({ "cmd", "alt", "ctrl", "shift" }, { overlayTimeoutMs = 1000 })
--
-- -- Bind some functions to keys
-- local reloadHammerspoon = function()
--   hs.application.launchOrFocus("Hammerspoon")
--   hs.reload()
-- end
--
-- -- YABAI
-- -- https://github.com/Hammerspoon/hammerspoon/issues/2570#issuecomment-792351312
-- -- Using hs.execute to execute yabai is slow, use below instead
-- function yabai(args)
--   -- Runs in background very fast
--   hs.task
--       .new("/usr/local/bin/yabai", nil, function(ud, ...)
--         print("stream", hs.inspect(table.pack(...)))
--         return true
--       end, args)
--       :start()
-- end

-- KEYCODES
-- https://github.com/Hammerspoon/hammerspoon/blob/master/extensions/keycodes/keycodes.lua#L67

-- forwarddelete -> the actual DEL key on the keyboard
-- delete -> backspace
-- hyperKey
--     :bind("h")
--     :toFunction("Reload Hammerspoon", reloadHammerspoon)
--     :bind("l")
--     :toFunction("Lock screen", hs.caffeinate.startScreensaver)
--     :bind("q")
--     :toFunction("Workspace 1", function()
--       yabai({ "-m", "space", "--focus", "1" })
--     end)
--     :bind("w")
--     :toFunction("Workspace 2", function()
--       yabai({ "-m", "space", "--focus", "2" })
--     end)
--     :bind("e")
--     :toFunction("Workspace 3", function()
--       yabai({ "-m", "space", "--focus", "3" })
--     end)
--     :bind("delete")
--     :toFunction("Workspace 4", function()
--       yabai({ "-m", "space", "--focus", "4" })
--     end)
--     :bind("space")
--     :toFunction("Window - Toggle Float", function()
--       yabai({ "-m", "window", "--toggle", "float" })
--     end)
--     :bind("p")
--     :toFunction("Window - Close", function()
--       hs.alert.show("asdasd")
--       print("CLOSE WINDOW")
--       yabai({ "-m", "window", "--close" })
--     end)

-- hk = HyperKey:new()

-- print(hs.execute("/Users/folke/.emacs.d/bin/org-capture > /dev/null 2>&1 &", true))

-- https://github.com/Hammerspoon/hammerspoon/issues/1252#issuecomment-290339778
-- myModifierMode = hs.hotkey.modal.new()
-- myModifier = hs.hotkey.bind({}, "tab", function()
--   -- on press
--   myModifierMode:enter()
--   myModifierMode.triggered = false
--   hs.alert.show("enter")
-- end, function()
--   -- on release
--   myModifierMode:exit()
--   if not myModifierMode.triggered then
--     -- if tab is pushed alone
--     hs.alert.show("not mymodifiermode.trigerred")
--     myModifier:disable()
--     hs.eventtap.keyStroke({}, "tab")
--     myModifier:enable()
--   else
--
--   end
-- end)

-- Sends "escape" if "caps lock" is held for less than .2 seconds, and no other keys are pressed.
--
-- local send_escape = false
-- local last_mods = {}
-- local control_key_timer = hs.timer.delayed.new(0.2, function()
--   send_escape = false
-- end)
--
-- hs.eventtap
--     .new({ hs.eventtap.event.types.flagsChanged }, function(evt)
--       local new_mods = evt:getFlags()
--       if last_mods["ctrl"] == new_mods["ctrl"] then
--         return false
--       end
--       if not last_mods["ctrl"] then
--         last_mods = new_mods
--         send_escape = true
--         control_key_timer:start()
--       else
--         if send_escape then
--           hs.eventtap.keyStroke({}, "escape")
--         end
--         last_mods = new_mods
--         control_key_timer:stop()
--       end
--       return false
--     end)
--     :start()
--
-- hs.eventtap
--     .new({ hs.eventtap.event.types.keyDown }, function(evt)
--       send_escape = false
--       return false
--     end)
--     :start()

-- spoon.SpoonInstall:andUse("ControlEscape", {})

-- https://github.com/jasonrudolph/keyboard/commit/01a7a5bd8a1e521756d1ec34769119ead5eee0b3

-- Credit for this implementation goes to @arbelt and @jasoncodes 🙇⚡️😻
--
--   https://gist.github.com/arbelt/b91e1f38a0880afb316dd5b5732759f1
--   https://github.com/jasoncodes/dotfiles/blob/ac9f3ac/hammerspoon/control_escape.lua

-- send_escape = false
-- last_keycode = 0

-- control_key_handler = function()
-- send_escape = false
-- end

-- control_key_timer = hs.timer.delayed.new(0.15, control_key_handler)

-- other_handler = function(evt)
-- send_escape = false
-- return false
-- end

-- other_tap = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, other_handler)
-- other_tap:start()

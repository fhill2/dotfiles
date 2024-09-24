-- Some Useful debugging functions...

hyper = { "cmd", "alt", "ctrl", "shift" }

keys = {
  "f1",
  "f2",
  "f3",
  "f4",
  "f5",
  "f6",
  "f7",
  "f8",
  "f9",
  "f10",
  "f11",
  "f12",
  "f13",
  "f14",
  "f15",
  "f16",
  "f17",
  "f18",
  "f19",
  "f20",
  "padclear",
  "padenter",
  "return",
  "tab",
  "space",
  "delete",
  "escape",
  "help",
  "home",
  "pageup",
  "forwarddelete",
  "end",
  "pagedown",
  "left",
  "right",
  "down",
  "up",
  "a",
  "b",
  "c",
  "d",
  "e",
  "f",
  "g",
  "h",
  "i",
  "j",
  "k",
  "l",
  "m",
  "n",
  "o",
  "p",
  "q",
  "r",
  "s",
  "t",
  "u",
  "v",
  "w",
  "x",
  "y",
  "z",
  "1",
  "2",
  "3",
  "4",
  "5",
  "6",
  "7",
  "8",
  "9",
  "0",
}

-- keys that do not work with karabiner hyper:
-- , . / \ backspace

for i, key in ipairs(keys) do
  hs.hotkey.bind(hyper, key, key, function()
    print(key .. "was pressed")
  end)
end

-- https://stackoverflow.com/questions/69241455/hammerspoon-remap-a-key-to-alt-modifier
-- local events = hs.eventtap.event.types
-- keyboardTracker = hs.eventtap.new({ events.keyDown }, function(e)
--   local keyCode = e:getKeyCode()
--   hs.alert.show(keyCode) -- for debugging only
-- end)
-- keyboardTracker:start()

hs.eventtap
    .new({ hs.eventtap.event.types.keyUp }, function(e)
      print(hs.inspect(e:getRawEventData()))
    end)
    :start()

print("========== DEBUGGING IS ENABLED ==========")

-- print(hs.keycodes.map.forwarddelete)
-- print(hs.inspect(hs.keycodesmap))

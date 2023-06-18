-- This does not work reliably. Modifiers are being held down unintentionally.
-- Decided to do this with karabiner (which supports mappings at kernel level )
TAB_KEYCODE = 48
local isTab = function(evt)
  return evt:getKeyCode(evt) == TAB_KEYCODE
end

local generate_event = function(down_up, keycode)
  return hs.eventtap.event.newEvent():setType(hs.eventtap.event.types.keyDown):setKeyCode(keycode)
end

TAB_PRESSED = false
KEY_PRESSED_WHEN_TAB_HELD = false

on_keydown = function(evt)
  local keycode = evt:getKeyCode()

  print("keycode", hs.inspect(keycode))

  if isTab(evt) then
    TAB_PRESSED = true
    KEY_PRESSED_WHEN_TAB_HELD = false
    return true -- eat Tab keydown
  else
    print("TAB_PRESSED", TAB_PRESSED)
    if TAB_PRESSED then
      -- https://www.hammerspoon.org/docs/hs.eventtap.event.html#newKeyEvent
      -- local kd = generate_event(hs.eventtap.event.types.keyDown, keycode)
      -- local ku = generate_event(hs.eventtap.event.types.keyUp, keycode)
      hs.timer.doAfter(
        0,
        function() -- there is a nominal delay after doing hs.hotkey:disable(), but setting it to 0 seems to suffice
          hs.eventtap.event.newKeyEvent(hs.keycodes.map.alt, true):post()
          hs.eventtap.event.newKeyEvent(keycode, true):post()
          hs.eventtap.event.newKeyEvent(keycode, false):post()
          hs.eventtap.event.newKeyEvent(hs.keycodes.map.alt, false):post()
        end
      )

      TAB_PRESSED = false
      KEY_PRESSED_WHEN_TAB_HELD = true
      return true
    end
  end
end

on_keyup = function(evt)
  hs.alert.show(hs.inspect(evt:getFlags()))
  if isTab(evt) then
    TAB_PRESSED = false
    hs.alert.show("RELEASE: isTab")
    if not KEY_PRESSED_WHEN_TAB_HELD then
      hs.alert.show("RELEASE: KEY_PRESSED_WHEN_TAB_HELD")
      hs.eventtap.event.newKeyEvent("tab", true):post()
      -- monitor_keyup_events:disable() -- temporarily disable so we can send an actual tab
      -- hs.eventtap.keyStroke({}, "tab", 0)
      -- monitor_keyup_events:enable()
      -- hs.eventtap.event.newKeyEvent(TAB_KEYCODE, false):post()
      return false -- do not eat the Tab release key
    end
  end
end

monitor_keydown_events = hs.eventtap.new({ hs.eventtap.event.types.keyDown }, on_keydown)
monitor_keydown_events:start()
monitor_keyup_events = hs.eventtap.new({ hs.eventtap.event.types.keyUp }, on_keyup)
monitor_keyup_events:start()

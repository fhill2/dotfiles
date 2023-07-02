print("SOURCED -------")

-- https://github.com/Hammerspoon/hammerspoon/discussions/3113

MODIFIER_KEYCODE_MAP = {
  [59] = "control", -- left control or caps lock
  [62] = "control", -- right control
  [56] = "shift",  -- left shift
  [60] = "shift",  -- right shift
  [58] = "alt",    -- left alt
  [61] = "alt",    -- left alt
  [55] = "command", -- left command
  [54] = "command", -- right command
}

-- keep the state of all modifier keys - this
MODIFIER_PRESSED = {
  ["tab"] = false,
  ["control"] = false,
  ["shift"] = false,
  ["alt"] = false,
  ["command"] = false,
}

local rawFlagMasks = hs.eventtap.event.rawFlagMasks

flagsTap = hs.eventtap
    .new({ hs.eventtap.event.types.flagsChanged }, function(e)
      -- only modifier keys, both downstroke, and upstroke, trigger this function
      -- therefore, there are 2 function calls per modifier keypress
      rawFlags = e:rawFlags()
      local rawEventData = e:getRawEventData()
      print(hs.inspect(rawFlags), hs.inspect(rawEventData), hs.inspect(e:getType()))
      -- print(hs.inspect(rawEventData))
      local keycode = rawEventData.CGEventData.keycode
      local is_pressed = rawEventData.CGEventData.flags ~= 256
      local modifier = MODIFIER_KEYCODE_MAP[keycode]
      -- print(modifier, is_pressed)
      MODIFIER_PRESSED[modifier] = is_pressed
      -- print(hs.inspect(MODIFIER_PRESSED))
    end)
    :start()
--
-- downTap = hs.eventtap
--     .new({ hs.eventtap.event.types.keyDown }, function(e)
--       -- all modifier keys do not execute this function
--       -- print(hs.inspect(e:getRawEventData()))
--       hs.alert.show(e:getKeyCode())
--     end)
--     :start()
--
-- upTap = hs.eventtap
--     .new({ hs.eventtap.event.types.keyUp }, function(e)
--       -- all modifier keys do not execute this function
--       hs.alert.show(e:getKeyCode())
--     end)
--     :start()

-- {
--   alphaShift                65536
-- alphaShiftStateless       =16777216
-- alternate                 = 524288
-- command                   = 1048576
-- control                   = 262144
-- deviceAlphaShiftStateless = 128
-- deviceLeftAlternate       = int32_t
-- deviceLeftCommand         = 8
-- deviceLeftControl         = 1
-- deviceLeftShift           = 2
-- deviceRightAlternate      = 64
-- deviceRightCommand        = 16
-- deviceRightControl        = 8192
-- deviceRightShift          = 4
-- help                      = 4194304
-- nonCoalesced              = 256
-- numericPad                = 2097152
-- secondaryFn               = 8388608
-- shift                     = 131072
--   alphaShift = 65536,
--   alphaShiftStateless = 16777216,
--   alternate = 524288,
--   command = 1048576,
--   control = 262144,
--   deviceAlphaShiftStateless = 128,
--   deviceLeftAlternate = 32,
--   deviceLeftCommand = 8,
--   deviceLeftControl = 1,
--   deviceLeftShift = 2,
--   deviceRightAlternate = 64,
--   deviceRightCommand = 16,
--   deviceRightControl = 8192,
--   deviceRightShift = 4,
--   help = 4194304,
--   nonCoalesced = 256,
--   numericPad = 2097152,
--   secondaryFn = 8388608,
--   shift = 131072
-- }

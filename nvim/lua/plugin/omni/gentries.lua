-- qtile check
-- get x server info for window
--

local gentries = {}

local function a(t)
  table.insert(gentries, t)
end

a({
title = "qtile check",
cmd = "qtile check",
})


a({
  title = "qtile restart",
  cmd = "qtile cmd-obj -o cmd -f restart",
})


a({
  title = "xwininfo -all --> no wm_class",
  cmd = "xwininfo -all",
})


a({
  title = "xprop --> use for qtile - wm_class",
  cmd = "xprop",
})


a({
  title = "qtile - show keybinds",
  cmd = [[qtile cmd-obj -o cmd -f display_kb | python -c 'import sys; print(eval(sys.stdin.read()))' | fzf]],
})


return gentries

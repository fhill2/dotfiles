 local tyrannical = require"tyrannical"

local dynamite = require"dynamite"
local cond   = require('dynamite.layout.conditional')
local corner = require('dynamite.suit.corner')


local mycustomtilelayout = dynamite {
    {
        {
            command = "kitty",
            widget = dynamite.widget.spawn,
        },
        {
            command = "kitty",
            widget = dynamite.widget.spawn,
        },
        {
            command = "kitty",
            widget = dynamite.widget.spawn,
        },
        {
            command = "kitty",
            widget = dynamite.widget.spawn,
        },
        {
            command = "kitty",
            widget = dynamite.widget.spawn,
        },
        layout = corner
    },
    reflow = true,
    layout = cond
}


-- Setup some tags
tyrannical.tags = {
  {
    name        = "Term",                 -- Call the tag "Term"
    init        = false,                   -- Load the tag on startup
    exclusive   = true,                   -- Refuse any other type of clients (by classes)
    screen      = {1,2},                  -- Create this tag on screen 1 and screen 2
    --layout      = awful.layout.suit.tile, -- Use the tile layout
    layout = mycustomtilelayout,
    selected    = true,
    class       = { --Accept the following classes, refuse everything else (because of "exclusive=true")
      "xterm" , "urxvt" , "aterm","URxvt","XTerm","konsole","terminator","gnome-terminal"
    }
  } ,
}

require"rc"

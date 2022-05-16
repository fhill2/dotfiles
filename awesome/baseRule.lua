local awful = require("awful")
local utils = require("utils")
local tyrannical = require("tyrannical")
local config = require("forgotten")

local tile   = require('dynamite.layout.ratio')
local cond   = require('dynamite.layout.conditional')
local corner = require('dynamite.suit.corner')
local fair   = require('dynamite.suit.fair')
local margin = require('wibox.container.margin')
local dynamite = require("dynamite")




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



tyrannical.tags = {
    {
        name = "Term",
        init        = true                                           ,
        exclusive   = true                                           ,
        icon        = utils.tools.invertedIconPath("term.png")       ,
        screen      = {config.scr.pri, config.scr.sec} ,
        layout      = mycustomtilelayout,
        focus_new   = true                                           ,
        selected    = true,
--         nmaster     = 2,
--         mwfact      = 0.6,
        index       = 1,
        class       = {
            "xterm" , "urxvt" , "aterm","URxvt","XTerm"
        },
    } ,
}


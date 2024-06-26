local gears = require("gears")
local awful = require("awful")
local naughty = require("naughty")
local exit_screen_show = require("main.exitscreen")
local dpi = require("beautiful.xresources").apply_dpi
local noop = require("main.helpers").noop
local vars = require("main.variables")

local floating = require("components.floating")


local window = {
  --kittybtm = false,
  --kittytop = false,
}
-- Resource Configuration
local launcher = vars.launcher
local shot = vars.shot
local emoji_picker = vars.emoji_picker
local clipmenu = vars.clipmenu
local terminal = vars.terminal
local modkey = vars.modkey

local M = gears.table.join(
 awful.key({}, "F3", function()
local cmd = "./omni.lua"
floating.raise_spawn_toggle({
 name = "kittybtm",
 cmd = cmd,
 --cmd = [[]], -- empty: sets pipe and spawns shell
 cwd = "~/dev/cl/lua/standalone/run",
 --on_open_cmds = "new-window --new-tab " .. cmd,
 --on_minimize_cmds = { "new-window --new-tab --tab-title fzf " .. cmd},
 on_minimize_cmds = {"focus-tab -m title:fzf"}
 })
  end, {
    description = "toggle kittybtm floater",
    group = "launcher",
  }),





 --- elivianava
  awful.key({ modkey }, "s", function()
    awful.hotkeys_popup.show_help(nil, awful.screen.focused())
  end, {
    description = "show help",
    group = "awesome",
  }),

  -- Toggle tray visibility
  awful.key({ modkey }, "=", function()
    local tag = awful.screen.focused().selected_tag
    tag.gap = dpi(4)
    awful.layout.arrange(awful.screen.focused())
  end, {
    description = "show gaps",
    group = "awesome",
  }),

  -- Toggle tray visibility
  awful.key({ modkey, "Shift" }, "=", function()
    local tag = awful.screen.focused().selected_tag
    tag.gap = dpi(0)
    awful.layout.arrange(awful.screen.focused())
  end, {
    description = "hide gaps",
    group = "awesome",
  }),

  -- Tag browsing
  awful.key({ modkey }, "Left", function()
    awful.tag.viewprev()
  end, {
    description = "view previous",
    group = "tag",
  }),

  awful.key({ modkey }, "Right", function()
    awful.tag.viewnext()
  end, {
    description = "view next",
    group = "tag",
  }),

  awful.key({ modkey }, "Tab", function()
    awful.tag.history.restore()
  end, {
    description = "go back",
    group = "tag",
  }),

  -- Standard program
  awful.key({ modkey }, "Return", function()
    awful.spawn(terminal)
  end, {
    description = "open a terminal",
    group = "launcher",
  }),

  awful.key({}, "F2", function()
    awful.spawn.easy_async_with_shell(
      --launcher .. "drun " .. theme.color_name,
      "rofi -show drun",
      noop
    )
  end, {
    description = "open app launcher",
    group = "launcher",
  }),


 
  awful.key({ modkey, "Shift" }, "d", function()
    awful.spawn.easy_async_with_shell(launcher .. "run " .. theme.color_name, noop)
  end, {
    description = "open command launcher",
    group = "launcher",
  }),

  awful.key({ modkey, "Shift" }, "x", function()
    exit_screen_show()
  end, {
    description = "show exit screen",
    group = "awesome",
  }),

  awful.key({ modkey }, "e", function()
    awful.spawn(emoji_picker)
  end, {
    description = "pick an emoji",
    group = "launcher",
  }),

  awful.key({ modkey }, "c", function()
    awful.spawn(clipmenu)
  end, {
    description = "launch clipmenu",
    group = "launcher",
  }),

  awful.key({ modkey, "Shift" }, "r", function()
    awesome.restart()
  end, {
    description = "reload awesome",
    group = "awesome",
  }),

  awful.key({ modkey, "Shift" }, "q", function()
    awesome.quit()
  end, {
    description = "quit awesome",
    group = "awesome",
  }),

  awful.key({ modkey }, "t", function()
    awful.layout.set(awful.layout.suit.tile)
  end, {
    description = "set to tiling mode",
    group = "layout",
  }),

  awful.key({ modkey }, "`", function()
    naughty.destroy_all_notifications()
  end, {
    description = "dismiss notification",
    group = "notifications",
  }),

  awful.key({ modkey }, "Print", function()
    awful.spawn.easy_async_with_shell(shot, noop)
  end, {
    description = "screenshot with borders",
    group = "misc",
  }),

  awful.key({}, "Print", function()
    awful.spawn.easy_async_with_shell("flameshot gui -p " .. os.getenv("HOME") .. "/Pictures/shots", noop)
  end, {
    description = "screenshot without borders",
    group = "misc",
  })
)

return M

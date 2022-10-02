version = "0.15.0"
local xplr = xplr
local keys = xplr.config.modes.builtin.default.key_bindings.on_key
home = os.getenv("HOME")
package.path = home .. "/.config/xplr/plugins/?/src/init.lua;" .. home .. "/.config/xplr/?.lua"
package.path = package.path .. ";" .. home .. "/dev/cl/lua/standalone/?.lua"

local inspect = require("lib.inspect")
local function log(msg)
  local outfile = home .. "/logs/xplr.log"
  local fp = io.open(outfile, "a")
  fp:write(string.format("\n%s", inspect(msg)))
  fp:close()
end

log("==== XPLR STARTUP =====")

require("icons")
require"colors"
--xplr.config.node_types.extension.py = { meta = { icon = "" }, style = { fg = "Red" } }

xplr.config.modes.builtin.default.key_bindings.on_key.space = {}

--xplr.config.general.focus_ui.style.fg = { Rgb = { 170, 150, 130 } }
xplr.config.general.focus_ui.style.fg = "White"

local extension = xplr.config.node_types.extension
local colors = {}
colors.ext = {
  { "less", { 255, 0, 255 } },
}

colors.file = {
  { "README", { 14, 0, 255 } },
}

for _, v in ipairs(colors.ext) do
  local ext = v[1]
  local rgb = v[2]
  if not extension[ext] then
    extension[ext] = { style = { fg = { Rgb = rgb } } }
  elseif not extension[ext].style then
    extension[ext].style = { fg = { Rgb = rgb } }
  end
end

local special = xplr.config.node_types.special
for _, v in ipairs(colors.file) do
  local ext = v[1]
  local rgb = v[2]
  if not special[ext] then
    special[ext] = { style = { fg = { Rgb = rgb } } }
  elseif not special[ext].style then
    special[ext].style = { fg = { Rgb = rgb } }
  end
end

--xplr.config.node_types.extension.less.style.fg = { Rgb = { 255, 0, 255 } }

log("XPLR SETUP FINISHED")

--xplr.config.node_types.extension["css"]. color = { Rgb = { 118, 118, 118 }}

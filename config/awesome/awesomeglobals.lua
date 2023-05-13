local awful = require('awful')

inspect = require("lib.inspect")
function log(msg)
local outfile = ("%s/logs/awesome.log"):format(os.getenv("HOME"))
local fp = io.open(outfile, "a")
fp:write(string.format("\n%s", inspect(msg)))
fp:close()
end

dump = function(t) log(t) end


run = function(cmds, cb)

local cmds = type(cmds) == "string" and {cmds} or cmds
for _, cmd in ipairs(cmds) do
awful.spawn.easy_async_with_shell(cmd, function(out)
  if cb then cb(out) end
end)
end
end

notify = function(msg)
require"naughty".notify({ title = "Achtung!", message = msg, timeout = 10000 })
end
--uv = require"luv"
--home = uv.os_homedir()
--mode = uv.fs_stat(home).mode


--vim = require"shared"
--vim.loop = require"luv"
--
--
--
function restart()
  local utils = require"utils"
for _, c in ipairs(client.get()) do
        local screen = c.screen.index
        local ctags = {}
        for i, t in ipairs(c:tags()) do
            ctags[i] = t.index
        end
        c.disp = utils.serialise({screen = screen, tags = ctags})
    end
  awesome.restart()
end

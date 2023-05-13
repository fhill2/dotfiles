local utils = require "utils"


function()
    for _, c in ipairs(client.get()) do
        local screen = c.screen.index
        local ctags = {}
        for i, t in ipairs(c:tags()) do
            ctags[i] = t.index
        end
        c.disp = utils.serialise({screen = screen, tags = ctags})
    end
end

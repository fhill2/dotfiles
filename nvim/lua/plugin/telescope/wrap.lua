-- [WIP]
-- extension wrapper
local telescope = require"telescope"
local actions = require'telescope.actions'
local actions_set = require'telescope.actions.set'
local sorters = require"telescope.sorters"
local config = require"telescope.config"
local my_actions = require"plugin.telescope.actions"
local wrap = {}


-- function wrap.repo(opts)
-- local opts = opts or {}
-- opts.attach_mappings = function(prompt_bufnr)
--       actions_set.select:replace(function(_, type)
--       my_actions.cd(prompt_bufnr)
--       end)
--       return true
--     end
-- opts.previewer = false

--   telescope.extensions.repo.list(opts)
-- end

function wrap.grep()

require"telescope.builtin".grep_string({
max_results=10000000,
search = "",
--sorter = sorters.get_generic_fuzzy_sorter,  -- fzf
})
end

return wrap

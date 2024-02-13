-- following options are the default
require("nvim-tree").setup({})
-- local lib = require'nvim-tree.lib'
-- local view = require'nvim-tree.view'

-- local nvimtree = {}

-- nvimtree.find_files = function(node)
-- --local node = lib.get_node_at_cursor()
-- telescope.find_files({ cwd = node.absolute_path })

-- end

-- nvimtree.live_grep = function(node)
-- telescope.live_grep({ cwd = node.absolute_path})
-- end

-- nvimtree.open = function(cwd)
--   if not cwd or cwd:match('~') then print('cant use relative ~ use /home/f1') return end
--   if not view.get_winnr() then vim.cmd('NvimTreeOpen') end
--   lib.change_dir(cwd)
-- end

-- return nvimtree

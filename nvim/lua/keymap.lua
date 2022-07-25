local wk = require("which-key")
--if leader key is space all of my custom mappings are added with mappings added by plugins
vim.g.mapleader = [[\]]
vim.g.maplocalleader = ","

wk.setup({ -- custom config
})


local normal_keymaps = {
    -- a = {
    --   function()
    --     require("plugin.nui.popup").popup({ close = true })
    --   end,
    --   "nui - close all floating windows",
    -- },
    a = {
  --    ["h"] = {
  --      function()
  --        require("util/old").send({ whole = true })
  --      end,
  --      "old - send whole file open window",
  --    },
  -- 
  --    o = {
  --    ["j"] = {
  --      function()
  --        require("util/old").show()
  --      end,
  --      "old - open window",
  --    },
  --  },

     ["d"] = { "<cmd>vsp<cr>", "new | window" },
     ["s"] = { "<cmd>sp<cr>", "new -- window" },
     ["f"] = { "<cmd>bo 30split<cr>", "new btm window" },
     ["a"] = { "<cmd>to 31split<cr>", "new top window " },
   },
  b = {
    name = "+buffer",
    ["b"] = { "<cmd>Telescope buffers show_all_buffers=true<cr>", "telescope Buffers" },
    ["c"] = { "<cmd>Bdelete!<cr>", "Delete buffer (without closing window)" },
    ["p"] = { "<cmd>:BufferLineCyclePrev<CR>", "Previous Buffer" },
    ["["] = { "<cmd>:BufferLineCyclePrev<CR>", "Previous Buffer" },
    ["n"] = { "<cmd>:BufferLineCycleNext<CR>", "Next Buffer" },
    ["]"] = { "<cmd>:BufferLineCycleNext<CR>", "Next Buffer" },
    ["g"] = { "<cmd>:BufferLinePick<CR>", "Goto Buffer" },
    -- "b"] = { "<cmd>:e #<cr>", "Switch to Other Buffer" },
    --["d"] = { "<cmd>:bd<CR>", "Delete Buffer" },
  },
  -- c = { "<cmd>NvimTreeToggle<cr>", "NvimTreeToggle" },
  s = {
    name = "+search",
    ["g"] = { "<cmd>Telescope live_grep<cr>", "telescope Live_Grep cwd interactive" },
    ["s"] = { ([[<cmd>lua require"plugin.telescope.wrap".grep()<cr>]]):format(f.cl), "telescope Live_Grep cl fuzzy" },
    ["c"] = { ([[<cmd>Telescope live_grep cwd=%s<cr>]]):format(f.cl), "telescope Live_Grep cl interactive" },
    ["b"] = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Buffer" },
    ["h"] = { "<cmd>Telescope command_history<cr>", "Command History" },
    ["m"] = { "<cmd>Telescope marks<cr>", "Jump to Mark" },

    ["r"] = { "<cmd>lua require('spectre').open()<CR>", "Replace (Spectre)" },
  },
  e = {
    name = "+errors",
    ["x"] = { "<cmd>TroubleToggle<cr>", "Trouble" },
    ["w"] = { "<cmd>TroubleWorkspaceToggle<cr>", "Workspace Trouble" },
    ["d"] = { "<cmd>TroubleDocumentToggle<cr>", "Document Trouble" },
    ["t"] = { "<cmd>TodoTrouble<cr>", "Todo Trouble" },
    ["T"] = { "<cmd>TodoTelescope<cr>", "Todo Telescope" },
    ["l"] = { "<cmd>lopen<cr>", "Open Location List" },
    ["q"] = { "<cmd>copen<cr>", "Open Quickfix List" },
  },
  l = {
    name = "+legendary",
    ["k"] = { function() require('legendary').find('keymaps') end, "Legendary - Keymaps" },
    ["c"] = { function() require('legendary').find('commands') end, "Legendary - Commands" },
    ["l"] = { function() require('plugin.legendary').find_by_desc('[LSP]') end, "Legendary - [LSP]" },
  },
  m = {
    name = "+snippets",
    ["m"] = {
      function()
        require("plugin.telescope.snippy").show()
      end,
      "show snippets [Snippy]",
    },
  },

  q = {
    name = "+qf",
    ["q"] = { [[<cmd>:copen<cr>]], "open qf" },
    ["w"] = { [[<cmd>call asyncrun#quickfix_toggle(8)<cr>]], "toggle quickfix list unfocused" },
  },
  r = {
    name = "+run",
    ["r"] = { [[<cmd>lua require"util.run.init".run()<cr>]], "run" },
    ["q"] = { [[<cmd>lua require"util.run.init".run_qtile()<cr>]], "run qtile" },
  }, 
  f = {
    name = "+files",
    -- ["g"] = { '<cmd>lua require("plugin.telescope.wrap").ff_files_home()<cr>', "Telescope - files - home" },
    -- ["f"] = { '<cmd>lua require("plugin.telescope.wrap").ff_files()<cr>', "Telescope - files - cwd" },
    ["d"] = { '<cmd>lua require("plugin.telescope.wrap").fb_dot()<cr>', "Telescope fb - dotfiles" },
    ["f"] = { '<cmd>lua require("plugin.telescope.wrap").fb_cwd()<cr>', "Telescope fb  - cwd" },
    ["v"] = { '<cmd>lua require("plugin.telescope.wrap").fb_dev()<cr>', "Telescope fb - dev" },
    ["h"] = { '<cmd>lua require("plugin.telescope.wrap").fb_home()<cr>', "Telescope fb - home" },
    ["r"] = { '<cmd>lua require("plugin.telescope.wrap").fb_repos()<cr>', "Telescope fb - repos" },
    ["n"] = { '<cmd>lua require("plugin.telescope.wrap").fb_notes()<cr>', "Telescope fb - notes" },
    ["m"] = { '<cmd>lua require("plugin.telescope.wrap").fb_notes_tags()<cr>', "Telescope fb - notes tags" },
    ["b"] = { '<cmd>lua require("plugin.telescope.wrap").fb_cbuf()<cr>', "telescope fb - current buffer" },
    ["n"] = { '<cmd>lua require("plugin.telescope.wrap").fb()<cr>', "telescope fb" },
    ["a"] = { "<cmd>Telescope find_files<cr>", "telescope Find Files" },
    ["t"] = { "<cmd>Telescope oldfiles<cr>", "telescope oldfiles (recent)" },

  },
  -- p = {
  --   name = "+neorg",
  --   ["p"] = { "<cmd>Neorg vlc save<cr>", "vlc save link" },
  --   ["o"] = { "<cmd>Neorg vlc open<cr>", "vlc open link" },
  -- },
  w = {
    name = "+windows",
    ["e"] = { "<C-W>p", "other-window" },
    ["w"] = { "<C-W>c", "close-window" },
    ["-"] = { "<C-W>s", "split-window-below" },
    ["|"] = { "<C-W>v", "split-window-right" },
    ["2"] = { "<C-W>v", "layout-double-columns" },
    ["j"] = { "<C-W>h", "window-left" },
    ["h"] = { "<C-W>j", "window-below" },
    ["k"] = { "<C-W>l", "window-right" },
    ["l"] = { "<C-W>k", "window-up" },
    ["H"] = { "<C-W>5<", "expand-window-left" },
    ["J"] = { ":resize +5", "expand-window-below" },
    ["L"] = { "<C-W>5>", "expand-window-right" },
    ["K"] = { ":resize -5", "expand-window-up" },
    ["="] = { "<C-W>=", "balance-window" },
    ["s"] = { "<C-W>s", "split-window-below" },
    ["v"] = { "<C-W>v", "split-window-right" },
  },
  --["`"] = { "<cmd>:e #<cr>", "prev<->current buffer" },
  ["<space>"] = {
    function()
      --require("plugin.telescope.find_frecency").show({ cwd = '/home/f1/dev/notes'})
      -- require("plugin.telescope.wrap").ff_files_dirs_home()
      --{ cwd = '/home/f1/dev/notes/dev/dev-linux/nvim' }
    end,
    "telescope find_frecency",
  },
  ["<space>"] = {"<cmd>Telescope resume<cr>", "Telescope resume" },
  ["?"] = { [[<cmd>lua require"cheatsheet".show_cheatsheet_telescope({bundled_cheatsheets=false, bundled_plugin_cheatsheets=false})<cr>]], "split-window-right" },
}


wk.register(normal_keymaps, { prefix = "<space>" })
-- false=which-key binds them, true=legendary binds them
require('legendary').bind_whichkey(normal_keymaps, { prefix = "<space>" }, false)


-- visual mode mappings
local visual_keymaps = {
    o = {
      function()
        require("util/old").send()
      end,
      "old - send visual open window",
    },
  m = {
    name = "+snippets",
    ["m"] = {
      function()
        require("plugin.snippy.save").save_snippet()
      end,
      "save snippet - visual [Snippy]",
    },
  },

    p = { function() require('legendary').find('commands') end, "Legendary - Commands" },
  l = {
    name = "+legendary",
    ["k"] = { function() require('legendary').find('keymaps') end, "Legendary - Keymaps" },
    ["l"] = { function() require('plugin.legendary').find_by_desc('[LSP]') end, "Legendary - [LSP]" },
  },
  f = { function() _G.format_github_repos_dotbot() end, "dotbot - format github repos yaml" },
}

wk.register(visual_keymaps, { prefix = "<space>", mode = "v" })
require('legendary').bind_whichkey(visual_keymaps, { prefix = "<space>", mode = "v" }, false)
    --["<space>aq"] = { function() require("plugin/nui").focus() end, "nui - focus cycle" },
    -- ["s"] = {
    --   function()
    --     require("omnimenu").show_telescope()
    --   end,
    --   "omnimenu",
    -- },
  -- d = {
  --   name = "+dirs",
  --   -- ["d"] = { '<cmd>lua require("plugin.telescope.wrap").ff_dirs_only()<cr>', "Telescope - dirs only - cwd" },
  --   -- ["f"] = { '<cmd>lua require("plugin.telescope.wrap").ff_dirs_only_home()<cr>', "Telescope - dirs only - home" },
  --   --["z"] = { "<cmd>Telescope zoxide list<cr>", "telescope zoxide" },
  --   --["p"] = { "<cmd>lua require'telescope'.extensions.project.project()<cr>", "telescope project" },
  --   --["r"] = { [[<cmd>lua require"plugin.telescope.repo".show()<cr>]], "telescope cl+repo" },
  -- },
 -- ["Tab"] = {
  --   name = "+tabpages",
  --   --["<tab>"] = { "<cmd>tabnew<CR>", "New Tab" },
  --   ["n"] = { "<cmd>tabnext<CR>", "Next" },
  --   ["d"] = { "<cmd>tabclose<CR>", "Close" },
  --   ["p"] = { "<cmd>tabprevious<CR>", "Previous" },
  --   ["]"] = { "<cmd>tabnext<CR>", "Next" },
  --   ["["] = { "<cmd>tabprevious<CR>", "Previous" },
  --   ["f"] = { "<cmd>tabfirst<CR>", "First" },
  --   ["l"] = { "<cmd>tablast<CR>", "Last" },
  -- },
    -- ["r"] = { '<cmd>lua require("plugin.telescope.wrap").ff_dirs_repos()<cr>', "Telescope - dirs - repos" },
    -- ["e"] = { '<cmd>lua require("plugin.telescope.wrap").ff_files_repos()<cr>', "Telescope file_browser - dotfiles" },
  -- n = {
  -- name = "+notes",
  --["n"] = { [[<cmd>lua require"plugin.telescope.wrap".notes_files()<cr>]], "telescope notes - files" },
  -- ["n"] = { '<cmd>lua require("plugin.telescope.wrap").ff_files_notes()<cr>', "Telescope - files - notes" },
  -- ["d"] = { '<cmd>lua require("plugin.telescope.wrap").ff_dirs_only_notes()<cr>', "Telescope - dirs - notes" },
  --["d"] = { [[<cmd>lua require"plugin.telescope.wrap".notes_dirs()<cr>]], "telescope notes - dirs" },
  -- },

-- old mappings 2022
-- wk.register({
--   ["<space>o"] = { name = "+omni" },
--   ["<space>oo"] = {
--     function()
--       require("plugin.omni.show").show()
--     end,
--     "telescope omnimenu",
--   },
-- })
-- wk.register({
--   ["<space>i"] = { name = "+sidebar" },
--   ["<space>ii"] = { "<cmd>SidebarNvimToggle<cr>", "sidebar toggle" },
-- })

-- ["<space>ae"] = {
--   function()
--     TelescopeGlobalState.persist.picker.close_windows(TelescopeGlobalState.persist)
--   end,
--   "telescope - close persistent",
-- },
-- ["<space>a<tab>"] = {
--   function()
--     TelescopeGlobalState.persist:focus()
--   end,
--   "telescope - focus persistent",
-- },


--- old mappings 2021
-- ["<space>1"] = { "1gt", "go to tabpage 1" },
-- ["<space>2"] = { "2gt", "go to tabpage 2" },
-- ["<space>3"] = { "3gt", "go to tabpage 3" },
-- ["<space>4"] = { "4gt", "go to tabpage 4" },
-- ["<space>5"] = { "5gt", "go to tabpage 5" },
-- ["<space>6"] = { "6gt", "go to tabpage 6" },
-- ["<space>7"] = { "7gt", "go to tabpage 7" },
-- ["<space>8"] = { "7gt", "go to tabpage 8" },
-- wk.register({
--   ["<space>1"] = { name = "+Trouble" },
--   ["<space>11"] = { "<cmd><cr>", "Trouble" },
-- })

--["<space>rs"] = { [[<cmd>lua require"util.run.init".sniprun()<cr>]], "run sniprun"},
--["<space>rd"] = { [[<cmd>lua require"sniprun.api".run_range(1, 20)<cr>]], "run sniprun range API"},
--["<space>rt"] = { [[<cmd>lua require"sniprun.api".run_string('print("hello world")', 'python')<cr>]], "run sniprun range API"},

--["<space>rr"] = { "<cmd>lua toggleterm_exec(1)<cr>", "run current file count=1 (toggleterm)" },
--["<space>rt"] = { "<cmd>lua toggleterm_exec(1)<cr>", "run last file count=1 (toggleterm)" },

----["<space>r1"] = { "<cmd>lua toggleterm_exec(1)<cr>", "run current file count=1 (toggleterm)" },
----["<space>r2"] = { "<cmd>lua toggleterm_exec(2)<cr>", "run current file count=2 (toggleterm)" },
----["<space>r3"] = { "<cmd>lua toggleterm_exec(3)<cr>", "run current file count=3 (toggleterm)" },

-- toggleterm jump to error msgs
--["<space>ree"] = { "<cmd>lua toggleterm_jump_traceback(1)<cr>", "jump to err msg count=1 (top) (toggleterm)" },
--["<space>re1"] = { "<cmd>lua toggleterm_jump_traceback(1)<cr>", "jump to err msg count=1 (top) (toggleterm)" },
--["<space>re2"] = { "<cmd>lua toggleterm_jump_traceback(2)<cr>", "jump to err msg count=2 (top) (toggleterm)" },
--["<space>re3"] = { "<cmd>lua toggleterm_jump_traceback(3)<cr>", "jump to err msg count=3 (top) (toggleterm)" },
--["<space>re4"] = { "<cmd>lua toggleterm_jump_traceback(4)<cr>", "jump to err msg count=4 (top) (toggleterm)" },






-- toggleterm
-- local opts = { noremap = true }
-- function _G.set_terminal_keymaps()
--   vim.api.nvim_buf_set_keymap(0, "t", "<C-Space>", [[<C-\><C-n>]], opts)
--   -- vim.api.nvim_buf_set_keymap(0, 't', 'jk', [[<C-\><C-n>]], opts)
--   --  vim.api.nvim_buf_set_keymap(0, 't', '<C-h>', [[<C-\><C-n><C-W>h]], opts)
--   --vim.api.nvim_buf_set_keymap(0, 't', '<C-j>', [[<C-\><C-n><C-W>j]], opts)
--   --vim.api.nvim_buf_set_keymap(0, 't', '<C-k>', [[<C-\><C-n><C-W>k]], opts)
--   --vim.api.nvim_buf_set_keymap(0, 't', '<C-l>', [[<C-\><C-n><C-W>l]], opts)
--   -- vim.api.nvim_buf_set_keymap(0, "t", "<A-1>", [[<cmd>lua focus_toggleterm(1)<cr>]], opts)
--   -- vim.api.nvim_buf_set_keymap(0, "t", "<A-2>", [[<cmd>lua focus_toggleterm(2)<cr>]], opts)
--   -- vim.api.nvim_buf_set_keymap(0, "t", "<A-3>", [[<cmd>lua focus_toggleterm(3)<cr>]], opts)
-- end

local a = require("util/keymap")
-- a.nnoremap("<A-1>", [[<cmd>lua focus_toggleterm(1)<cr>]])
-- a.nnoremap("<A-2>", [[<cmd>lua focus_toggleterm(2)<cr>]])
-- a.nnoremap("<A-3>", [[<cmd>lua focus_toggleterm(3)<cr>]])

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
-- vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

--- NORMAL MAPPINGS ----

-- as tab is autocomplete, set normal tab as S-Tab
a.inoremap("<S-Tab>", "<Tab>")

-- a.allremap("<C-Space>", [[<cmd>luafile %<cr>]])

local opts = { noremap = true } -- silent = true
-- vim.keymap.set("n", "<C-Space>", telescope_actions.close_picker, {})
-- vim.keymap.set("i", "<C-Space>", telescope_actions.close_picker, {})

-- SPLITS FOCUSING
a.nnoremap("<C-h>", "<C-w>h")
a.nnoremap("<C-j>", "<C-w>j")
a.nnoremap("<C-k>", "<C-w>k")
a.nnoremap("<C-l>", "<C-w>l")

a.allremap("<F14>", "<cmd>qa!<cr>")

-- cut copy paste undo
--api.nvim_set_keymap('', '<C-x>', 'd', {})
--api.nvim_set_keymap('!', '<C-x>', '<Esc>d', {})
--a.vnoremap("<C-x>", "<Esc>d")
--a.vnoremap("<C-c>", "y<Esc>")

a.inoremap("<C-h>", "<Left>")
a.inoremap("<C-j>", "<Down>")
a.inoremap("<C-k>", "<Up>")
a.inoremap("<C-l>", "<Right>")
a.cnoremap("<C-h>", "<Left>")
a.cnoremap("<C-j>", "<Down>")
a.cnoremap("<C-k>", "<Up>")
a.cnoremap("<C-l>", "<Right>")

a.nnoremap("<C-Space>", [[<cmd>lua require"plugin.telescope.actions".toggle_focus_picker()<cr>]])
a.inoremap("<C-Space>", [[<cmd>lua require"plugin.telescope.actions".toggle_focus_picker()<cr>]])
a.nnoremap("<C-a>", [[<cmd>lua require"plugin.telescope.actions".toggle_focus_previewer()<cr>]])
a.inoremap("<C-a>", [[<cmd>lua require"plugin.telescope.actions".toggle_focus_previewer()<cr>]])

a.nnoremap("<C-.>", [[<cmd>lua require"plugin.telescope.actions".close_or_resume()<cr>]])
a.inoremap("<C-.>", [[<cmd>lua require"plugin.telescope.actions".close_or_resume()<cr>]])
--nmap <space>lP :call Paste(v:register, "l", "P")<CR>
--a.nnore('p', 'call Paste(v:register, "l", "p")<CR>')
--a.nmap('P', ':call Paste(v:register, "v", "P")<CR>')
--a.nmap('p', [[:call Paste('+', "v", "p")<CR>]])

--a.nmap('P', '<cmd>lua f.paste("P")<cr>')
--a.nmap('p', '<cmd>lua f.paste("p")<cr>')

-- no noremap for <Plug> mappings
--a.nmap("P", "<Plug>(unimpaired-put-above-reformat)")
--<C-l> <Right>


-- quicker beginning of line
--a.nnoremap("<S-f>", "^i")

-- manual reload whole config
--a.allremap('<A-p>', [[<cmd>lua require("util/resource").resource_init_only()<cr>]])
--a.allremap("<A-p>", [[<cmd>lua f.reload_current_file()<cr>]])

-- local function t(str)
--   return vim.api.nvim_replace_termcodes(str, true, true, true)
-- end

-- function _G.pum_up(dir)
--   dump("trig")
--   dump(vim.fn.pumvisible())
--   return vim.fn.pumvisible() == 1 and t'<Esc>ki' or t'<Up>'
-- end
-- function _G.pum_down(dir)
--   dump("trig")
--   dump(vim.fn.pumvisible())
--   return vim.fn.pumvisible() == 1 and t'<Esc>ji' or t'<Down>'
-- end
--api.nvim_set_keymap("i", "<Up>", [[pumvisible() ? "\<Esc>ki" : "<Up>"]], { expr = true })
--api.nvim_set_keymap("i", "<Down>", [[pumvisible() ? "\<Esc>ji" : "<Down>"]], { expr = true })

--vim.api.nvim_set_keymap("i", "<Up>", 'v:lua.pum_up_down("<Up>")', { expr = true, noremap = true })
--vim.api.nvim_set_keymap("i", "<Down>", 'v:lua.pum_up_down("<Down>")', { expr = true, noremap = true })

-- function _G.up_down(key)
--   dump("up down trig")
--   if require"cmp".visible() then
--     vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>' .. key .. 'i', true, true, true), '', true)
--   else
--     vim.api.nvim_feedkeys(key, '', true)
--   end
-- end
-- vim.api.nvim_set_keymap("i", "<Up>", '', { expr = true, noremap = true })
-- vim.api.nvim_set_keymap("i", "<Down>", 'v:lua.up_down("j")', { expr = true, noremap = true })

-- local opts = { noremap = true, silent = true }
-- local nvim_set_keymap = vim.api.nvim_set_keymap
-- local mappings = require("xplr.mappings")
-- local set_keymap = mappings.set_keymap
-- local on_previewer_set_keymap = mappings.on_previewer_set_keymap
-- wk.register({
--   ["<space>1"] = { name = "+xplr" },
-- })
--
-- nvim_set_keymap("n", "<space>11", '<Cmd>lua require"xplr".open()<CR>', opts) -- open/focus cycle
-- set_keymap("t", "<space>11", '<Cmd>lua require"xplr".focus()<CR>', opts) -- open/focus cycle
--
-- nvim_set_keymap("n", "<space>12", '<Cmd>lua require"xplr".close()<CR>', opts)
-- set_keymap("t", "<space>12", '<Cmd>lua require"xplr".close()<CR>', opts)
--
-- nvim_set_keymap("n", "<space>13", '<Cmd>lua require"xplr".toggle()<CR>', opts)
-- set_keymap("t", "<space>13", '<Cmd>lua require"xplr".toggle()<CR>', opts)

-- on_previewer_set_keymap("t", "<space>14", '<Cmd>lua require"xplr.actions".scroll_previewer_up()<CR>', opts)
-- on_previewer_set_keymap("t", "<space>15", '<Cmd>lua require"xplr.actions".scroll_previewer_down()<CR>', opts)
--
-- vim.api.nvim_set_keymap("n", "<space>xx", "<cmd>Trouble<cr>", { silent = true, noremap = true })
-- vim.api.nvim_set_keymap("n", "<space>xw", "<cmd>Trouble lsp_workspace_diagnostics<cr>", { silent = true, noremap = true })
-- --vim.api.nvim_set_keymap("n", "<space>xx", "<cmd>Trouble lsp_document_diagnostics<cr>",
-- --  {silent = true, noremap = true}
-- --)
-- vim.api.nvim_set_keymap("n", "<space>xl", "<cmd>Trouble loclist<cr>", { silent = true, noremap = true })
-- vim.api.nvim_set_keymap("n", "<space>xq", "<cmd>Trouble quickfix<cr>", { silent = true, noremap = true })
-- vim.api.nvim_set_keymap("n", "gR", "<cmd>Trouble lsp_references<cr>", { silent = true, noremap = true })

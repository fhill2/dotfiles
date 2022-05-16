local api = vim.api

local wk = require("which-key")
vim.g.mapleader = [[\]]
vim.g.maplocalleader = ","





--- [A] leader misc ---
wk.register({
  ["<space>a"] = { name = "+misc" },
  ["<space>aw"] = {
    function()
      require("plugin.nui.popup").popup({ close = true })
    end,
    "nui - close all floating windows",
  },
  --["<space>aq"] = { function() require("plugin/nui").focus() end, "nui - focus cycle" },
  ["<space>as"] = {
    function()
      require("omnimenu").show_telescope()
    end,
    "omnimenu",
  },
  ["<space>ah"] = {
    function()
      require("util/old").send({ whole = true })
    end,
    "old - send whole file open window",
  },
  ["<space>aj"] = {
    function()
      require("util/old").show()
    end,
    "old - open window",
  },
  ["<space>ae"] = {
    function()
      TelescopeGlobalState.persist.picker.close_windows(TelescopeGlobalState.persist)
    end,
    "telescope - close persistent",
  },
  ["<space>a<tab>"] = {
    function()
      TelescopeGlobalState.persist:focus()
    end,
    "telescope - focus persistent",
  },
  ["<space>ad"] = { "<cmd>vsp<cr>", "new | window" },
  ["<space>af"] = { "<cmd>sp<cr>", "new -- window" },
  ["<space>ac"] = { "<cmd>bo 30split<cr>", "new btm window" },
  ["<space>av"] = { "<cmd>to 31split<cr>", "new top window " },
}, {
  mode = "n",
})

wk.register({
  ["<space>ag"] = {
    function()
      require("util/old").send()
    end,
    "old - send visual open window",
  },
}, { mode = "v" })

wk.register({
  ["<space>w"] = { name = "+windows" },
  ["<space>we"] = { "<C-W>p", "other-window" },
  ["<space>ww"] = { "<C-W>c", "close-window" },
  ["<space>w-"] = { "<C-W>s", "split-window-below" },
  ["<space>w|"] = { "<C-W>v", "split-window-right" },
  ["<space>w2"] = { "<C-W>v", "layout-double-columns" },
  ["<space>wj"] = { "<C-W>h", "window-left" },
  ["<space>wh"] = { "<C-W>j", "window-below" },
  ["<space>wk"] = { "<C-W>l", "window-right" },
  ["<space>wl"] = { "<C-W>k", "window-up" },
  ["<space>wH"] = { "<C-W>5<", "expand-window-left" },
  ["<space>wJ"] = { ":resize +5", "expand-window-below" },
  ["<space>wL"] = { "<C-W>5>", "expand-window-right" },
  ["<space>wK"] = { ":resize -5", "expand-window-up" },
  ["<space>w="] = { "<C-W>=", "balance-window" },
  ["<space>ws"] = { "<C-W>s", "split-window-below" },
  ["<space>wv"] = { "<C-W>v", "split-window-right" },
}, {
  mode = "n",
})
--- [s] leader Search ---
wk.register({
  ["<space>s"] = { name = "+search" },
  ["<space>sg"] = { "<cmd>Telescope live_grep<cr>", "telescope Live_Grep cwd interactive" },
  ["<space>ss"] = { ([[<cmd>lua require"plugin.telescope.wrap".grep()<cr>]]):format(f.cl), "telescope Live_Grep cl fuzzy" },
  ["<space>sc"] = { ([[<cmd>Telescope live_grep cwd=%s<cr>]]):format(f.cl), "telescope Live_Grep cl interactive" },
  ["<space>sb"] = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Buffer" },
  ["<space>sd"] = {
    function()
      require("telescope.builtin").lsp_document_symbols({
        symbols = { "Class", "Function", "Method", "Constructor", "Interface", "Module" },
      })
    end,
    "Goto Symbol",
  },
  ["<space>sh"] = { "<cmd>Telescope command_history<cr>", "Command History" },
  ["<space>sm"] = { "<cmd>Telescope marks<cr>", "Jump to Mark" },

  ["<space>sr"] = { "<cmd>lua require('spectre').open()<CR>", "Replace (Spectre)" },
})

--- [m] leader Snippets ---
wk.register({
  ["<space>m"] = { name = "+snippets" },
  ["<space>mm"] = {
    function()
      require("plugin.snippy.save").save_snippet()
    end,
    "save snippet - visual [Snippy]",
  },
}, { mode = "v" })

wk.register({
  ["<space>m"] = { name = "+snippets" },
  ["<space>mm"] = {
    function()
      require("plugin.telescope.snippy").show()
    end,
    "show snippets [Snippy]",
  },
}, { mode = "n" })

wk.register({
  ["<space>n"] = { name = "+notes" },
  ["<space>nn"] = { [[<cmd>lua require"plugin.telescope.notes".files()<cr>]], "telescope notes - files" },
  ["<space>nd"] = { [[<cmd>lua require"plugin.telescope.notes".dirs()<cr>]], "telescope notes - dirs" },
})

--- [t] leader NvimTree (or terminal) ---
--wk.register({})

--- [b] leader Buffers ---
wk.register({
  ["<space>b"] = { name = "+buffers" },
  ["<space>bb"] = { "<cmd>Telescope buffers show_all_buffers=true<cr>", "telescope Buffers" },
  ["<space>bc"] = { "<cmd>Bdelete!<cr>", "Delete buffer (without closing window)" },
  ["<space>bp"] = { "<cmd>:BufferLineCyclePrev<CR>", "Previous Buffer" },
  ["<space>b["] = { "<cmd>:BufferLineCyclePrev<CR>", "Previous Buffer" },
  ["<space>bn"] = { "<cmd>:BufferLineCycleNext<CR>", "Next Buffer" },
  ["<space>b]"] = { "<cmd>:BufferLineCycleNext<CR>", "Next Buffer" },
  ["<space>bg"] = { "<cmd>:BufferLinePick<CR>", "Goto Buffer" },
  -- "b"] = { "<cmd>:e #<cr>", "Switch to Other Buffer" },
  --["d"] = { "<cmd>:bd<CR>", "Delete Buffer" },
})

--- [<tab>] leader Tabpages ---
wk.register({
  ["<space><tab>"] = { name = "+tabs" },
  --["<tab>"] = { "<cmd>tabnew<CR>", "New Tab" },
  ["<space><tab>n"] = { "<cmd>tabnext<CR>", "Next" },
  ["<space><tab>d"] = { "<cmd>tabclose<CR>", "Close" },
  ["<space><tab>p"] = { "<cmd>tabprevious<CR>", "Previous" },
  ["<space><tab>]"] = { "<cmd>tabnext<CR>", "Next" },
  ["<space><tab>["] = { "<cmd>tabprevious<CR>", "Previous" },
  ["<space><tab>f"] = { "<cmd>tabfirst<CR>", "First" },
  ["<space><tab>l"] = { "<cmd>tablast<CR>", "Last" },
})

--- [d] leader Dirs---
wk.register({
  ["<space>d"] = { name = "+dirs" },
  ["<space>dz"] = { "<cmd>Telescope zoxide list<cr>", "telescope zoxide" },
  ["<space>dp"] = { "<cmd>lua require'telescope'.extensions.project.project()<cr>", "telescope project" },
  ["<space>dr"] = { [[<cmd>lua require"plugin.telescope.repo".show()<cr>]], "telescope cl+repo" },
})

--- [f] leader Files---
wk.register({
  ["<space>f"] = { name = "+files" },
  ["<space>ff"] = { "<cmd>Telescope find_files<cr>", "telescope Find Files" },
  ["<space>fr"] = { "<cmd>Telescope oldfiles<cr>", "telescope oldfiles (recent)" },
  ["<space>fb"] = { "<cmd>Telescope file_browser<cr>", "telescope File Browser" },
})

wk.register({
  ["<space>e"] = { name = "+errors" },
  ["<space>ex"] = { "<cmd>TroubleToggle<cr>", "Trouble" },
  ["<space>ew"] = { "<cmd>TroubleWorkspaceToggle<cr>", "Workspace Trouble" },
  ["<space>ed"] = { "<cmd>TroubleDocumentToggle<cr>", "Document Trouble" },
  ["<space>et"] = { "<cmd>TodoTrouble<cr>", "Todo Trouble" },
  ["<space>eT"] = { "<cmd>TodoTelescope<cr>", "Todo Telescope" },
  ["<space>el"] = { "<cmd>lopen<cr>", "Open Location List" },
  ["<space>eq"] = { "<cmd>copen<cr>", "Open Quickfix List" },
})

--- [z] leader lsp
wk.register({
  ["<space>z"] = { name = "+lsp" },


  ["<space>zdl"] = { [[<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>]], "lsp diagnostic --> loclist" },

  --["<space>zd"] = { name = "+diagnostics" },
  --["<space>zd<space>"] = { [[<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<cr>]], "lsp show diagnostic" },
  --["<space>zdd"] = { [[<cmd>lua require'lspsaga.diagnostic'.show_line_diagnostics()<cr>]], "saga show diagnostic" },

  --["<space>zdpp"] = { [[<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_prev()<cr>]], "saga diagnostic prev" },
  --["<space>zdp<space>"] = { [[<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>]], "lsp diagnostic prev" },

  --["<space>zdnn"] = { [[<cmd>lua require'lspsaga.diagnostic'.lsp_jump_diagnostic_next()<cr>]], "lsp diagnostic next" },
  --["<space>zdn<space>"] = { [[<cmd>lua vim.lsp.diagnostic.goto_next()<cr>]], "lsp diagnostic next" },

  --["<space>zx"] = { name = "+definition" },
  --["<space>zxp"] = { [[<cmd>lua require'lspsaga.provider'.preview_definition()<cr>]], "saga definition preview" },
  --["<space>zx<space>"] = { [[<cmd>lua vim.lsp.buf.definition()<cr>]], "lsp show definition" },
  ["<space>zxt"] = { [[<cmd>lua vim.lsp.buf.type_definition()<cr>]], "lsp show type definition" },

  ["<space>zc"] = { name = "+code actions" },
  ["<space>zc<space>"] = { [[<cmd>lua vim.lsp.buf.code_action()<cr>]], "lsp show code action" },
  ["<leaderzcc"] = { [[<cmd>lua require('lspsaga.codeaction').code_action()<cr>]], "saga show code action" },
  ["<space>zcr"] = { [[<cmd>lua require('lspsaga.codeaction').range_code_action()<cr>]], "saga show range code action" },

  --["<space>zr"] = { name = "+rename" },
  --["<space>zr<space>"] = { [[<cmd>lua vim.lsp.buf.rename()<cr>]], "lsp buf rename" },

  --["<space>zs"] = { name = "+signature help" },
  --["<space>zs<space>"] = { [[<cmd>lua vim.lsp.buf.signature_help()<cr>]], "lsp signature help" },
  --["<space>zss"] = { [[<cmd>lua require('lspsaga.signaturehelp').signature_help()<cr>]], "saga signature help" },

  --["<space>zw"] = { name = "+workspace folders" },
  --["<space>zwa"] = { [[<cmd>lua vim.lsp.buf.add_workspace_folder()<cr>]], "lsp add workspace folder" },
  --["<space>zwd"] = { [[<cmd>lua vim.lsp.buf.remove_workspace_folder()<cr>]], "lsp delete workspace folder" },
  --["<space>zwf"] = { [[<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<cr>]], "lsp find list workspace folders" },

  --["<space>zh"] = { name = "+hover" },
  --["<space>zh<space>"] = { [[<cmd>lua vim.lsp.buf.hover()<cr>]], "lsp hover" },
  --["<space>zhh"] = { [[<cmd>lua require('lspsaga.hover').render_hover_doc()<cr>]], "saga hover" },
  --["<space>zhp"] = { [[<cmd>lua require('lspsaga.hover').smart_scroll_hover(1)<cr>]], "saga scroll hover down" },
  --["<space>zhn"] = { [[<cmd>lua require('lspsaga.hover').smart_scroll_hover(-1)<cr>]], "saga scroll hover up" },

  -- still to try out:
  -- :Telescope lsp_references
  --["<space>ze"] = { [[<cmd>lua vim.lsp.buf.declaration()<cr>]], "lsp declaration" }, -- using navigators for now until i can work out what it is
  ["<space>zi"] = { [[<cmd>lua vim.lsp.buf.implementation()<cr>]], "lsp implementation" },
  -- ["<space>zb"] = { [[<cmd>lua vim.lsp.buf.references()<cr>]], "lsp references" }, -- could use native only references bqf
  -- ["<space>zf"] = { [[<cmd>lua require('lspsaga.provider').lsp_finder()<cr>]], "saga lsp finder" }, -- shows references and definitions which can be nice, but less info than telescope and native+bqf, also broken
})

--["<C-a>w"] = { function() end, "" },

--- [] leader roots/aliases ---
wk.register({
  --["<space>`"] = { "<cmd>:e #<cr>", "prev<->current buffer" },
  --["<space><space>"] = { "<cmd>Telescope find_files<cr>", "telescope Find Files" },
  ["<space><space>"] = {
    function()
      require("plugin.telescope.find_frecency").show({ cwd = '/home/f1'})
      --{ cwd = '/home/f1/dev/notes/dev/dev-linux/nvim' }
    end,
    "telescope find_frecency",
  },
  -- ["<space>1"] = { "1gt", "go to tabpage 1" },
  -- ["<space>2"] = { "2gt", "go to tabpage 2" },
  -- ["<space>3"] = { "3gt", "go to tabpage 3" },
  -- ["<space>4"] = { "4gt", "go to tabpage 4" },
  -- ["<space>5"] = { "5gt", "go to tabpage 5" },
  -- ["<space>6"] = { "6gt", "go to tabpage 6" },
  -- ["<space>7"] = { "7gt", "go to tabpage 7" },
  -- ["<space>8"] = { "7gt", "go to tabpage 8" },
})

-- wk.register({
--   ["<space>1"] = { name = "+Trouble" },
--   ["<space>11"] = { "<cmd><cr>", "Trouble" },
-- })

--- [c] browser / nvim tree
wk.register({
  ["<space>c"] = { "<cmd>NvimTreeToggle<cr>", "NvimTreeToggle" },
})

wk.register({
  ["<space>q"] = { name = "+qf" },
  ["<space>qq"] = { [[<cmd>:copen<cr>]], "open qf" },
  ["<space>qw"] = { [[<cmd>call asyncrun#quickfix_toggle(8)<cr>]], "toggle quickfix list unfocused" },
})
--- [r] run current file / terminal focus
wk.register({
  ["<space>r"] = { name = "+run" },
  ["<space>rr"] = { [[<cmd>lua require"util.run.init".run()<cr>]], "run" },
  ["<space>rq"] = { [[<cmd>lua require"util.run.init".run_qtile()<cr>]], "run qtile" },
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
})

wk.register({
  ["<space>o"] = { name = "+omni" },
  ["<space>oo"] = {
    function()
      require("plugin.omni.show").show()
    end,
    "telescope omnimenu",
  },
})

wk.register({
  ["<space>i"] = { name = "+sidebar" },
  ["<space>ii"] = { "<cmd>SidebarNvimToggle<cr>", "sidebar toggle" },
})

-- [p] neorg linktrigger
wk.register({
  ["<space>p"] = { name = "+neorg linktrigger" },
  ["<space>pp"] = { "<cmd>Neorg vlc save<cr>", "vlc save link" },
  ["<space>po"] = { "<cmd>Neorg vlc open<cr>", "vlc open link" },
})
-- toggleterm
local opts = { noremap = true }
function _G.set_terminal_keymaps()
  vim.api.nvim_buf_set_keymap(0, "t", "<C-Space>", [[<C-\><C-n>]], opts)
  -- vim.api.nvim_buf_set_keymap(0, 't', 'jk', [[<C-\><C-n>]], opts)
  --  vim.api.nvim_buf_set_keymap(0, 't', '<C-h>', [[<C-\><C-n><C-W>h]], opts)
  --vim.api.nvim_buf_set_keymap(0, 't', '<C-j>', [[<C-\><C-n><C-W>j]], opts)
  --vim.api.nvim_buf_set_keymap(0, 't', '<C-k>', [[<C-\><C-n><C-W>k]], opts)
  --vim.api.nvim_buf_set_keymap(0, 't', '<C-l>', [[<C-\><C-n><C-W>l]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<A-1>", [[<cmd>lua focus_toggleterm(1)<cr>]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<A-2>", [[<cmd>lua focus_toggleterm(2)<cr>]], opts)
  vim.api.nvim_buf_set_keymap(0, "t", "<A-3>", [[<cmd>lua focus_toggleterm(3)<cr>]], opts)
end

local a = require("util/keymap")
a.nnoremap("<A-1>", [[<cmd>lua focus_toggleterm(1)<cr>]])
a.nnoremap("<A-2>", [[<cmd>lua focus_toggleterm(2)<cr>]])
a.nnoremap("<A-3>", [[<cmd>lua focus_toggleterm(3)<cr>]])

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

--- NORMAL MAPPINGS ----

-- as tab is autocomplete, set normal tab as S-Tab
a.inoremap("<S-Tab>", "<Tab>")

-- floating
a.allremap("<F4>", [[<cmd>luafile %<cr>]])

-- SPLITS FOCUSING
a.nnoremap("<C-h>", "<C-w>h")
a.nnoremap("<C-j>", "<C-w>j")
a.nnoremap("<C-k>", "<C-w>k")
a.nnoremap("<C-l>", "<C-w>l")

a.allremap("<F14>", "<cmd>qa!<cr>")

-- cut copy paste undo
--api.nvim_set_keymap('', '<C-x>', 'd', {})
--api.nvim_set_keymap('!', '<C-x>', '<Esc>d', {})
a.vnoremap("<C-x>", "<Esc>d")
a.vnoremap("<C-c>", "y<Esc>")

--nmap <space>lP :call Paste(v:register, "l", "P")<CR>
--a.nnore('p', 'call Paste(v:register, "l", "p")<CR>')
--a.nmap('P', ':call Paste(v:register, "v", "P")<CR>')
--a.nmap('p', [[:call Paste('+', "v", "p")<CR>]])

--a.nmap('P', '<cmd>lua f.paste("P")<cr>')
--a.nmap('p', '<cmd>lua f.paste("p")<cr>')

-- no noremap for <Plug> mappings
a.nmap("P", "<Plug>(unimpaired-put-above-reformat)")
a.nmap("p", "<Plug>(unimpaired-put-below-reformat)")

a.nnoremap("<C-v>", "p")
a.inoremap("<C-v>", "<Esc>p")
a.cnoremap("<C-v>", "<C-R>+")

-- never want to suspend nvim
a.allremap("<C-z>", "<Nop>")

-- insert new line enter in normal mode
a.nnoremap("<cr>", [[o<Esc>]])

-- save
a.nnoremap("<c-s>", "<cmd>w<cr>")
a.vnoremap("<c-s>", "<cmd>w<cr>")

-- quicker beginning of line
a.nnoremap("<S-f>", "^i")

-- manual reload whole config
--a.allremap('<A-p>', [[<cmd>lua require("util/resource").resource_init_only()<cr>]])
a.allremap("<A-p>", [[<cmd>lua f.reload_current_file()<cr>]])

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

local opts = { noremap = true, silent = true }
local nvim_set_keymap = vim.api.nvim_set_keymap
local mappings = require("xplr.mappings")
local set_keymap = mappings.set_keymap
local on_previewer_set_keymap = mappings.on_previewer_set_keymap
wk.register({
  ["<space>1"] = { name = "+xplr" },
})

nvim_set_keymap("n", "<space>11", '<Cmd>lua require"xplr".open()<CR>', opts) -- open/focus cycle
set_keymap("t", "<space>11", '<Cmd>lua require"xplr".focus()<CR>', opts) -- open/focus cycle

nvim_set_keymap("n", "<space>12", '<Cmd>lua require"xplr".close()<CR>', opts)
set_keymap("t", "<space>12", '<Cmd>lua require"xplr".close()<CR>', opts)

nvim_set_keymap("n", "<space>13", '<Cmd>lua require"xplr".toggle()<CR>', opts)
set_keymap("t", "<space>13", '<Cmd>lua require"xplr".toggle()<CR>', opts)

on_previewer_set_keymap("t", "<space>14", '<Cmd>lua require"xplr.actions".scroll_previewer_up()<CR>', opts)
on_previewer_set_keymap("t", "<space>15", '<Cmd>lua require"xplr.actions".scroll_previewer_down()<CR>', opts)

vim.api.nvim_set_keymap("n", "<space>xx", "<cmd>Trouble<cr>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "<space>xw", "<cmd>Trouble lsp_workspace_diagnostics<cr>", { silent = true, noremap = true })
--vim.api.nvim_set_keymap("n", "<space>xx", "<cmd>Trouble lsp_document_diagnostics<cr>",
--  {silent = true, noremap = true}
--)
vim.api.nvim_set_keymap("n", "<space>xl", "<cmd>Trouble loclist<cr>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "<space>xq", "<cmd>Trouble quickfix<cr>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "gR", "<cmd>Trouble lsp_references<cr>", { silent = true, noremap = true })

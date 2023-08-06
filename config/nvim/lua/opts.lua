local cmd = vim.cmd
local indent = 2

vim.o.swapfile = false -- Living on the edge
vim.opt.mouse = "a"    -- enable mouse mode
vim.cmd([[set winbar=%=%m\ %F]])
vim.cmd("set title")
vim.cmd("set shell=/bin/zsh")
--set titlestring+=%f\ filename
-- vim.cmd [[set titlestring=nv ]]
-- vim.opt.titlestring = [[nv \ %{substitute(getcwd(),\ $HOME,\ '~',\ '')} - %f\]]

-- vim.opt.titlestring = [[(%{getcwd()})%) %- (%{expand("%:~:.:h")})]]

vim.opt.titlestring = [[%{getcwd()} - %{expand("%f")}]]

vim.g.mapleader = [[\]]
vim.g.maplocalleader = ","
vim.opt.autowrite = true          -- enable auto write # auto save after certain vim commands have been executed
vim.opt.clipboard = "unnamedplus" -- sync with system clipboard
vim.opt.conceallevel = 2          -- Hide * markup for bold and italic
vim.opt.concealcursor = "n"       -- Hide * markup for bold and italic
vim.opt.confirm = false           -- confirm to save changes before exiting modified buffer
vim.opt.cursorline = true         -- Enable highlighting of the current line
vim.opt.expandtab = true          -- Use spaces instead of tabs

vim.opt.grepprg = "rg --vimgrep"
vim.opt.grepformat = "%f:%l:%c:%m"
vim.opt.hidden = true         -- Enable modified buffers in background
vim.opt.ignorecase = true     -- Ignore case
vim.opt.inccommand = "split"  -- preview incremental substitute
vim.opt.joinspaces = false    -- No double spaces with join after a dot
vim.opt.number = true         -- Print line number
vim.opt.pumblend = 10         -- Popup blend
vim.opt.pumheight = 10        -- Maximum number of entries in a popup
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.scrolloff = 4         -- Lines of context
vim.opt.shiftround = true     -- Round indent
vim.opt.shiftwidth = indent   -- Size of an indent
vim.opt.showmode = false      -- dont show mode since we have a statusline
vim.opt.sidescrolloff = 8     -- Columns of context
vim.opt.signcolumn = "yes"    -- Always show the signcolumn, otherwise it would shift the text each time
vim.opt.smartcase = true      -- Don't ignore case with capitals
vim.opt.smartindent = true    -- Insert indents automatically
vim.opt.splitbelow = true     -- Put new windows below current
vim.opt.splitright = true     -- Put new windows right of current
vim.opt.tabstop = indent      -- Number of spaces tabs count for
vim.opt.termguicolors = true  -- True color support
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.updatetime = 200               -- save swap file and trigger CursorHold
vim.opt.wildmode = "longest:full,full" -- Command-line completion mode
vim.opt.wrap = true                    -- Disable line wrap
vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
vim.opt.laststatus = 3

vim.opt.list = true -- Show some invisible characters (tabs...
--vim.opt.listchars = "eol:$,tab:>-,trail:~,extends:>,precedes:<"

--[[ vim.bo.expandtab = true -- Use spaces instead of tabs
vim.bo.shiftwidth = indent -- Size of an indent
vim.bo.smartindent = true -- Insert indents automatically
vim.bo.undofile = true ]]
--vim.o.shortmess = "IToOlxfitn" -- TODO: fix printing of writes

-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()" -- TreeSitter folding
-- vim.opt.foldlevel = 6
-- vim.opt.foldmethod = "expr" -- TreeSitter folding
--vim.opt.guifont = "FiraCode Nerd Font:h12"

--- f: turn auto indent of
---vim.cmd([[setlocal nocindent]])
---vim.cmd([[setlocal nosmartindent]])

vim.o.timeout = true
vim.o.ttimeout = true

-- https://github.com/neovim/neovim/issues/2051
vim.o.timeoutlen = 250 -- keep normal mode mappings slow, but keep it as low as possible so G is fast in normal mode etc
vim.o.ttimeoutlen = 0  -- quick escape from insert mode

vim.cmd([[com -nargs=1 -complete=command Redir :execute "tabnew | pu=execute(\'" . <q-args> . "\') | setl nomodified"]])

vim.cmd([[augroup terminal_setup | au!]])
vim.cmd([[autocmd TermOpen * nnoremap <buffer><LeftRelease> <LeftRelease>i]])
vim.cmd([[augroup end]])

--turn off auto commenting for every buffer
vim.cmd([[autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o]])
vim.cmd([[autocmd FileType norg set nofoldenable]])

-- for python codeblocks in mardkown - 4 spaces
vim.cmd([[autocmd Filetype markdown set tabstop=4 shiftwidth=4 ]])

--vim.cmd[[autocmd FileType * ColorizerAttachToBuffer]]
-- _G.set_colorscheme = function()
--   print("colorscheme set")
--   vim.cmd("colorscheme material")
-- end
--vim.cmd [[autocmd VimEnter * lua _G.set_colorscheme()]]

--vim.cmd([[autocmd Filetype python call luaeval('require"util.python".autocmd(_A)', expand('<abuf>'))]])

-- https://github.com/skywind3000/asyncrun.vim/wiki/Quickfix-Best-Practice

-- syntax highlighting for vagrant

-- _G.telescope_last_editor_win = function() end

-- add ! to silent will still load config if color scheme isnt available (bootstrap)
-- vim.cmd('silent! colorscheme material')

-- manually turn on nvim basic syntax highlighting if there is no treesitter module for that language

--vim.cmd("packadd nvim-treesitter")
-- packadd nvim-treesitter as packer isnt installing into start
--vim.cmd([[autocmd BufWinEnter * lua require'plugin.treesitter'.decide_syntax()]])

--vim.lsp.set_log_level("debug")
--vim.cmd[[syntax on]]

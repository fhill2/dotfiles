

require("packer").startup(function(use)
use({"nvim-treesitter/nvim-treesitter"})
use({"folke/tokyonight.nvim"})
--   use({
  --   "shaunsingh/nord.nvim",
  --   config = function() require"nord" end,
  -- })
use({'marko-cerovac/material.nvim'})
end)

vim.g.tokyonight_dev = true
vim.g.tokyonight_style = "night"
vim.g.tokyonight_sidebars = {
  "qf",
  "vista_kind",
  "terminal",
  "packer",
  "spectre_panel",
  "NeogitStatus",
  "help",
}
vim.g.tokyonight_cterm_colors = false
vim.g.tokyonight_terminal_colors = true
vim.g.tokyonight_italic_comments = true
vim.g.tokyonight_italic_keywords = true
vim.g.tokyonight_italic_functions = false
vim.g.tokyonight_italic_variables = false
vim.g.tokyonight_transparent = true
vim.g.tokyonight_hide_inactive_statusline = true
vim.g.tokyonight_dark_sidebar = true
vim.g.tokyonight_dark_float = true
vim.g.tokyonight_colors = {}
-- vim.g.tokyonight_colors = { border = "orange" }

require("tokyonight").colorscheme()

vim.g.material_style = "deep ocean"
require('material').setup({

  contrast = {
    sidebars = false, -- Enable contrast for sidebar-like windows ( for example Nvim-Tree )
    floating_windows = false, -- Enable contrast for floating windows
    line_numbers = false, -- Enable contrast background for line numbers
    sign_column = false, -- Enable contrast background for the sign column
    cursor_line = false, -- Enable darker background for the cursor line
    non_current_windows = false, -- Enable darker background for non-current windows
    popup_menu = false, -- Enable lighter background for the popup menu
  },

  italics = {
    comments = false, -- Enable italic comments
    keywords = false, -- Enable italic keywords
    functions = false, -- Enable italic functions
    strings = false, -- Enable italic strings
    variables = false -- Enable italic variables
  },

  contrast_filetypes = { -- Specify which filetypes get the contrasted (darker) background
  "terminal", -- Darker terminal background
  "packer", -- Darker packer background
  "qf" -- Darker qf list background
},

high_visibility = {
  lighter = false, -- Enable higher contrast text for lighter style
  darker = false -- Enable higher contrast text for darker style
},

disable = {
  colored_cursor = false, -- Disable the colored cursor
  borders = false, -- Disable borders between verticaly split windows
  background = false, -- Prevent the theme from setting the background (NeoVim then uses your teminal background)
  term_colors = false, -- Prevent the theme from setting terminal colors
  eob_lines = false -- Hide the end-of-buffer lines
},

lualine_style = "default", -- Lualine style ( can be 'stealth' or 'default' )

async_loading = true, -- Load parts of the theme asyncronously for faster startup (turned on by default)

custom_highlights = {} -- Overwrite highlights with your own
})

require'nvim-treesitter.configs'.setup({
ensure_installed = "all",
highlight = { enable = true},
})


vim.cmd"syntax off"

print("RANN")

require("indent_blankline").setup({
  space_char_blankline = " ",
  show_current_context = true,
  show_current_context_start = true,
  use_treesitter = true,
  buftype_exclude = { "terminal", "nofile" },
  filetype_exclude = {
    "norg",
    "markdown",
    "help",
    "startup",
    "packer",
    "lsp-installer",
    "text",
    "help",
    "startify",
    "dashboard",
    "packer",
    "neogitstatus",
    "NvimTree",
    "Trouble",
  },
})

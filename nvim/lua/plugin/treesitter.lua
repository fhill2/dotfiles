local treesitter_shared_config = {
  ensure_installed = "all",
  --ensure_installed = {
  --  "css", "html", "javascript", "json", "lua", "php", "toml", "yaml", "typescript", "python", "norg", "norg_meta", "norg_table"
  --}
  highlight = {
    enable = true, -- false will disable the whole extensio
  },
}

local treesitter_nvim_config = {
  indent = { enable = false },
  incremental_selection = {
    enable = false,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
  refactor = {
    highlight_definitions = { enable = false },
    highlight_current_scope = { enable = false},
    smart_rename = { enable = true, keymaps = { smart_rename = "grr" } },
    navigation = {
      enable = false,
      keymaps = {
        goto_definition = "gnd",
        list_definitions = "gnD",
        list_definitions_toc = "gO",
        goto_next_usage = "<a-*>",
        goto_previous_usage = "<a-#>",
      },
    },
  },
}


if _G.f_nvimpager then
treesitter_config = treesitter_shared_config
else
treesitter_config = vim.tbl_deep_extend("keep", treesitter_shared_config, treesitter_nvim_config)
end

require'nvim-treesitter.configs'.setup(treesitter_config)
vim.cmd("syntax off")

-- not using yet
local f_treesitter = {}
f_treesitter.decide_syntax = function()
  local cbuf = vim.api.nvim_get_current_buf()
  local lang = require("nvim-treesitter.parsers").get_buf_lang(cbuf)
    if vim.api.nvim_win_get_config(0).zindex == nil and vim.api.nvim_buf_get_name(cbuf) ~= "" then
    if vim._ts_has_language(lang) then
      vim.cmd("syntax off")
    else
      vim.cmd("syntax on")
    end
  end
end
return f_treesitter

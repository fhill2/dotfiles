local M = {}
local wk = require("which-key")
M.attach = function(client, bufnr)
  lsp_keymaps = {
    -- { 'gr', require('navigator.reference').async_ref, description = "[LSP] navigator - references definitions" },
    -- { '<Leader>gr', require('navigator.reference').reference, description = "[LSP] navigator - reference" }, -- reference deprecated
    -- { 'g0', require('navigator.symbols').document_symbols, description = '[LSP] navigator - document symbols' },
    {
      "gD",
      function()
        vim.lsp.buf.declaration({ border = "rounded", max_width = 80 })
      end,
      description = "[LSP] native - declaration",
    },
    -- { 'gp', require('navigator.definition').definition_preview, description = '[LSP] navigator - definition preview' },
    -- { '<Leader>gt', require('navigator.treesitter').buf_ts, description = '[LSP] navigator - treesitter' },
    -- { '<Leader>gT', require('navigator.treesitter').bufs_ts, description = '[LSP] navigator - treesitter all buffers' },
    {
      "K",
      function()
        vim.lsp.buf.hover({ popup_opts = { border = "single", max_width = 80 } })
      end,
      description = "[LSP] navigator - hover docs",
    },

    -- { '<Space>ca', require('navigator.codeAction').code_action, description = '[LSP] navigator - code action', mode = 'n' },
    { "<leader>cv", vim.lsp.buf_range_code_action,                     description = "[LSP] native - ranged code action",
                                                                                                                            mode =
      "v" },                                                                                                      -- not working
    { "<leader>ca", require("code_action_menu").open_code_action_menu, description = "[LSP] code action menu" },
    { "<leader>cA", vim.lsp.buf.code_action,                           description = "[LSP] native - code action" },

    -- { '<Space>rn', require('navigator.rename').rename, description = '[LSP] navigator - rename' },rename
    -- { "<Leader>gi", vim.lsp.buf.incoming_calls, description = "[LSP] navigator - incoming fn calls" },
    -- { "<Leader>go", vim.lsp.buf.outgoing_calls, description = "[LSP] navigator - outgoing fn calls" },
    -- { '<leader>G', require('navigator.diagnostics').show_buf_diagnostics, description = '[LSP] navigator - show current buffer diagnostics' },
    { "gG",         require("telescope.builtin").diagnostics,          description = "[LSP] telescope - diagnostics" },
    -- { '<Leader>dt', require('navigator.diagnostics').toggle_diagnostics, description = '[LSP] navigator - toggle virtual text diagnostics' },
    {
      "]d",
      function()
        vim.diagnostic.goto_next({ enable_popup = false })
      end,
      description = "navigator - prev diagnostic",
    },
    {
      "[d",
      function()
        vim.diagnostic.goto_prev({ enable_popup = false })
      end,
      description = "navigator - next diagnostic",
    },
    -- { ']r', require('navigator.treesitter').goto_next_usage, description = '[LSP] navigator - next reference' },
    -- { '[r', require('navigator.treesitter').goto_previous_usage, description = '[LSP] navigator - prev reference' },
    -- { '<Leader>k', require('navigator.dochighlight').hi_symbol, description = '[LSP] navigator - doc highlight' },
    -- { '<Space>wa', require('navigator.workspace').add_workspace_folder, description = '[LSP] navigator - add workspace folder' },
    -- { '<Space>wr', require('navigator.workspace').remove_workspace_folder, description = '[LSP] navigator - remove workspace folder' },
    -- { '<Space>wl', require('navigator.workspace').list_workspace_folders, description = '[LSP] navigator - list workspace folders' },
    -- { '<leader>ff', function() vim.lsp.buf.format({ async = true }) end, description = '[LSP] native - format whole buffer', mode = 'n' },
    -- {
    -- 	"<leader>ff",
    -- 	function()
    -- 		_G.lsp_formatting()
    -- 	end,
    -- 	description = "[LSP] native - format whole buffer",
    -- 	mode = "n",
    -- },
    --{ '<leader>fr', vim.lsp.buf_range_formatting, description = '[LSP] navigator - format range', mode = 'v' },
    -- { '<Space>la', require('navigator.codelens').run_action, description = '[LSP] navigator - codelens action', mode = 'n' },

    -- my own lsp mappings
    { "gr", require("telescope.builtin").lsp_references,  description = "[LSP] telescope - references" },
    { "gd", require("telescope.builtin").lsp_definitions, description = "[LSP] - telescope - definition" },
    ----buf_set_keymap("n", "<leader>G", vim.diagnostic.set_loclist())
    {
      "<leader>0",
      require("telescope.builtin").lsp_document_symbols,
      description = "[LSP] telescope - document symbols",
    },
    {
      "<leader>W",
      require("telescope.builtin").lsp_workspace_symbols,
      description = "[LSP] telescope - workspace symbols",
    },
    {
      "gw",
      require("telescope.builtin").lsp_workspace_symbols,
      description = "[LSP] telescope - workspace symbols",
    },
    ----buf_set_keymap("n", "<leader>W", require("telescope.builtin").dynamic_workspace_symbols)
    { "gi",        require("telescope.builtin").lsp_implementations, description = "[LSP] telescope - implementation" },
    {
      "<space>D",
      require("telescope.builtin").lsp_type_definitions,
      description = "[LSP] telescope - type definition",
    },
    {
      "<leader>D",
      require("telescope.builtin").lsp_type_definitions,
      description = "[LSP] telescope - type definition",
    },
    {
      "<leader>l",
      require("lsp_lines").toggle,
      description = "[LSP] lsp_lines toggle",
    },
    { "<leader>r", vim.lsp.buf.rename,                               description = "[LSP] - native - rename" },
    -- BROKEN
    --{ 'gL', require('navigator.diagnostics').show_diagnostics, description = '[LSP] navigator - show diagnostics' },
    -- --{ ']O', 'diagnostic.set_loclist()', '' }, -- broken
    -- UNUSED
    --{ '<C-LeftMouse>', vim.lsp.buf_definition, description = '[LSP] navigator - definition' },
    --{ 'g<LeftMouse>', vim.lsp.buf_implementation, description = '[LSP] navigator - implementation' },
    -- -- { '<Space>D', 'type_definition()', '' }, -- using telescope
    --{ 'gi', vim.lsp.buf_implementation, description = '[LSP] native - implementation' },
    --{ 'gW', require('navigator.workspace').workspace_symbol, description = '[LSP] navigator - workspace symbols' },
    --{ '<c-]>', require('navigator.definition').definition, description = '[LSP] navigator - definition' },
    --{ 'gd', require('navigator.definition').definition, description = '[LSP] navigator - definition' },
    --{ mode = 'i', '<M-k>', 'signature_help()', '' }, -- auto shows by defailt
    --{ '<c-k>', 'signature_help()', '' },
  }
  require("legendary").keymaps(lsp_keymaps)
  -- register labels for the keys above
  -- i could use require"legendary".bind_whichkey() but I'd have to use vim.keymap.set format
  wk.register({
    ["<leader>"] = {
      c = { name = "+code action" },
    },
  })
end
return M

local util = require "lspconfig/util"
local lspconfig = require "lspconfig"


require 'rust-tools'.setup()
require 'lsp.null-ls'.setup()


local signs = {
  { name = "DiagnosticSignError", text = "", texthtl = "DiagnosticError" },
  { name = "DiagnosticSignWarn", text = "", texthl = "DiagnosticWarn" },
  { name = "DiagnosticSignHint", text = "", texthl = "DiagnosticHint" },
  { name = "DiagnosticSignInfo", text = "", texthl = "DiagnosticInfo" },
}
-- trouble
-- error = "",
-- warning = "",
-- hint = "",
-- information = "",
-- other = "﫠",

for _, sign in ipairs(signs) do
  vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "", texthtl = sign.texthl })
end
vim.lsp.protocol.CompletionItemKind = {
  " [text]",
  " [method]",
  "ƒ [function]",
  " [constructor]",
  " [field]",
  " [variable]",
  " [class]",
  " [interface]",
  " [module]",
  " [property]",
  " [unit]",
  " [value]",
  " [enum]",
  " [keyword]",
  "﬌ [snippet]",
  " [color]",
  " [file]",
  " [reference]",
  " [dir]",
  " [enummember]",
  " [constant]",
  " [struct]",
  "  [event]",
  " [operator]",
  " [type]",
}


-- vim.diagnostic.config = {
--   enable_popup = false,
--   }





-- https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Avoiding-LSP-formatting-conflicts
local lsp_formatting = function(bufnr)
  vim.lsp.buf.format({
    filter = function(clients)
      -- filter out clients that you don't want to use
      return vim.tbl_filter(function(client)
        -- nothing filtered yet
        return client
        --return client.name ~= "tsserver"
      end, clients)
    end,
    bufnr = bufnr,
  })
end
-- if you want to set up formatting on save, you can use this as a callback
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})


local on_attach = function(client, bufnr)
  --https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Avoiding-LSP-formatting-conflicts
  if client.supports_method("textDocument/formatting") then
    vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup,
      buffer = bufnr,
      callback = function()
        lsp_formatting(bufnr)
      end,
    })
  end

  --https://github.com/mjlbach/nix-dotfiles/blob/master/home-manager/configs/neovim/init.lua

  -- FormatRange = function()
  --   local start_pos = vim.api.nvim_buf_get_mark(0, "<")
  --   local end_pos = vim.api.nvim_buf_get_mark(0, ">")
  --   vim.lsp.buf.range_formatting({}, start_pos, end_pos)
  -- end
  -- vim.cmd([[
  --     command! -range FormatRange  execute 'lua FormatRange()'
  --     ]])

  -- vim.cmd([[
  --     command! Format execute 'lua vim.lsp.buf.formatting()'
  --     ]])

  require('legendary').bind_keymaps({
    { 'gr', require('navigator.reference').async_ref, description = "[LSP] navigator - references definitions" },
    { '<Leader>gr', require('navigator.reference').reference, description = "[LSP] navigator - reference" }, -- reference deprecated
    { 'g0', require('navigator.symbols').document_symbols, description = '[LSP] navigator - document symbols' },
    { 'gD', function() vim.lsp.buf.declaration({ border = 'rounded', max_width = 80 }) end, description = '[LSP] native - declaration' },
    { 'gp', require('navigator.definition').definition_preview, description = '[LSP] navigator - definition preview' },
    { '<Leader>gt', require('navigator.treesitter').buf_ts, description = '[LSP] navigator - treesitter' },
    { '<Leader>gT', require('navigator.treesitter').bufs_ts, description = '[LSP] navigator - treesitter all buffers' },
    { 'K', function() vim.lsp.buf.hover({ popup_opts = { border = 'single', max_width = 80 } }) end, description = '[LSP] navigator - hover docs' },

    { '<Space>ca', require('navigator.codeAction').code_action, description = '[LSP] navigator - code action', mode = 'n' },
    { '<Space>cA', vim.lsp.buf_range_code_action, description = '[LSP] native - ranged code action', mode = 'v' }, -- not working
    { "<leader>ca", require('code_action_menu').open_code_action_menu, description = "[LSP] code action menu" },
    { "<space>cA", vim.lsp.buf.code_action, description = "[LSP] native - code action" },

    { '<Space>rn', require('navigator.rename').rename, description = '[LSP] navigator - rename' },
    { '<Leader>gi', vim.lsp.buf.incoming_calls, description = '[LSP] navigator - incoming fn calls' },
    { '<Leader>go', vim.lsp.buf.outgoing_calls, description = '[LSP] navigator - outgoing fn calls' },
    { '<leader>G', require('navigator.diagnostics').show_buf_diagnostics, description = '[LSP] navigator - show current buffer diagnostics' },
    { "gG", require("telescope.builtin").diagnostics, description = "[LSP] telescope - diagnostics" },
    { '<Leader>dt', require('navigator.diagnostics').toggle_diagnostics, description = '[LSP] navigator - toggle virtual text diagnostics' },
    { ']d', function() vim.diagnostic.goto_next({ enable_popup = false }) end, description = 'navigator - prev diagnostic' },
    { '[d', function() vim.diagnostic.goto_prev({ enable_popup = false }) end, description = 'navigator - next diagnostic' },
    { ']r', require('navigator.treesitter').goto_next_usage, description = '[LSP] navigator - next reference' },
    { '[r', require('navigator.treesitter').goto_previous_usage, description = '[LSP] navigator - prev reference' },
    { '<Leader>k', require('navigator.dochighlight').hi_symbol, description = '[LSP] navigator - doc highlight' },
    { '<Space>wa', require('navigator.workspace').add_workspace_folder, description = '[LSP] navigator - add workspace folder' },
    { '<Space>wr', require('navigator.workspace').remove_workspace_folder, description = '[LSP] navigator - remove workspace folder' },
    { '<Space>wl', require('navigator.workspace').list_workspace_folders, description = '[LSP] navigator - list workspace folders' },
    { '<leader>ff', function() vim.lsp.buf.format({ async = true }) end, description = '[LSP] native - format whole buffer', mode = 'n' },
    --{ '<leader>fr', vim.lsp.buf_range_formatting, description = '[LSP] navigator - format range', mode = 'v' },
    { '<Space>la', require('navigator.codelens').run_action, description = '[LSP] navigator - codelens action', mode = 'n' },

    -- my own lsp mappings
    { "<leader>r", require("telescope.builtin").lsp_references, description = "[LSP] telescope - references" },
    { "gd", require("telescope.builtin").lsp_definitions, description = "[LSP] - telescope - definition" },
    ----buf_set_keymap("n", "<leader>G", vim.diagnostic.set_loclist())
    { "<leader>0", require("telescope.builtin").lsp_document_symbols, description = "[LSP] telescope - document symbols" },
    { "<leader>W", require("telescope.builtin").lsp_workspace_symbols, description = "[LSP] telescope - workspace symbols" },
    { "gw", require("telescope.builtin").lsp_workspace_symbols, description = "[LSP] telescope - workspace symbols" },
    ----buf_set_keymap("n", "<leader>W", require("telescope.builtin").dynamic_workspace_symbols)
    { "gi", require("telescope.builtin").lsp_implementations, description = "[LSP] telescope - implementation" },
    { "<space>D", require("telescope.builtin").lsp_type_definitions, description = "[LSP] telescope - type definition" },
    { "<leader>D", require("telescope.builtin").lsp_type_definitions, description = "[LSP] telescope - type definition" },
    -- BROKEN
    --{ 'gL', require('navigator.diagnostics').show_diagnostics, description = '[LSP] navigator - show diagnostics' },
    -- --{ ']O', 'diagnostic.set_loclist()', '' }, -- broken
    -- UNUSED
    --{ '<C-LeftMouse>', vim.lsp.buf_definition, description = '[LSP] navigator - definition' },
    --{ 'g<LeftMouse>', vim.lsp.buf_implementation, description = '[LSP] navigator - implementation' },
    -- -- { '<Space>D', 'type_definition()', '' }, -- using telescope
    --{ 'gi', vim.lsp.buf_implementation, description = '[LSP] native - implementation' },
    -- --{ '<Leader>re', 'rename()', '' },
    --{ 'gW', require('navigator.workspace').workspace_symbol, description = '[LSP] navigator - workspace symbols' },
    --{ '<c-]>', require('navigator.definition').definition, description = '[LSP] navigator - definition' },
    --{ 'gd', require('navigator.definition').definition, description = '[LSP] navigator - definition' },
    --{ mode = 'i', '<M-k>', 'signature_help()', '' }, -- auto shows by defailt
    --{ '<c-k>', 'signature_help()', '' },
  })

  print("on attach")

end -- end on_attach



local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

-- https://github.com/Conni2461/dotfiles/blob/191ace7b9002547e36cf2ef26ed1f26013e6a31d/.config/nvim/lua/module/lsp.lua#L195

-- lspconfig.sumneko_lua.setup(require("lua-dev").setup({
--   lspconfig = {
--     cmd = { "lua-language-server" },
--     --on_attach = on_attach,
--     capabilities = capabilities,
--     settings = {
--       Lua = {
--         telemetry = {
--           enable = false,
--         },
--         runtime = {
--           version = "LuaJIT",
--           path = vim.split(package.path, ";"),
--         },
--         diagnostics = {
--           enable = true,
--           globals = { "vim", "describe", "it", "before_each", "teardown", "pending" },
--         },
--         workspace = {
--           maxPreload = 1000,
--           preloadFileSize = 1000,
--         },
--       },
--     }
--   }
-- }))


--https://github.com/neovim/nvim-lspconfig/issues/500#issuecomment-851247107
local function get_python_path(workspace)

  -- use pyenv virtualenv plugin
  -- pyenv virtualenv plugin doesnt set $VIRTUAL_ENV variable, so below cant be used
  --local pyenv_activated = vim.api.nvim_exec("!pyenv local", true) ~= "system" or false
  --print("pyenv_activated is: " .. pyenv_activated)

  -- Use activated virtualenv.
  if vim.env.VIRTUAL_ENV then
    return util.path.join(vim.env.VIRTUAL_ENV, "bin", "python")
  end

  -- Check for a poetry.lock file
  if vim.fn.glob(util.path.join(workspace, "poetry.lock")) ~= "" then
    return util.path.join(vim.fn.trim(vim.fn.system "poetry env info -p"), "bin", "python")
  end

  -- Find and use virtualenv from pipenv in workspace directory.
  local match = vim.fn.glob(util.path.join(workspace, "Pipfile"))
  if match ~= "" then
    local venv = vim.fn.trim(vim.fn.system("PIPENV_PIPFILE=" .. match .. " pipenv --venv"))
    return util.path.join(venv, "bin", "python")
  end

  -- Fallback to system Python.
  return vim.fn.exepath "python3" or vim.fn.exepath "python" or "python"
end

lspconfig.pyright.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  on_init = function(client)
    print('pyright on_init')
    --dump('pyright on_init')
    --client.config.settings.python.pythonPath = "/usr/bin/python"
    client.config.settings.python.pythonPath = get_python_path(client.config.root_dir)
  end,
  flags = { allow_incremental_sync = true, debounce_text_changes = 500 },
  settings = {
    python = {
      formatting = { provider = 'black' },
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = 'workspace',
      },
    },
  }
}


-- local servers = {
--   rnix = {},
--   bashls = {},
--   cssls = {},
--   dockerls = {},
--   html = {},
--   jsonls = {},
--   tsserver = {}, -- tsserver needs a npm project in root for it to start
--   vimls = {},
--   yamlls = {},
--   --ember = {},
--   clangd = {},
--   -- null-ls doesnt have to be added to servers
--   --["null-ls"] = {},
--   rust_analyzer = {},
-- }


-- for server, config in pairs(servers) do
--   lspconfig[server].setup(vim.tbl_deep_extend("force", {
--     --on_attach = on_attach,
--     capabilities = capabilities,
--     -- flags = {
--     --   debounce_text_changes = 150,
--     -- },
--   }, config))
-- end



require 'navigator'.setup(
  {
    icons = {
      icons = false, -- set to false to use system default ( if you using a terminal does not have nerd/icon)
      -- Code action
      code_action_icon = '🏏', -- "",
      -- code lens
      code_lens_action_icon = '👓',
      -- Diagnostics
      diagnostic_head = '🐛',
      diagnostic_err = '📛',
      diagnostic_warn = '👎',
      diagnostic_info = [[👩]],
      diagnostic_hint = [[💁]],

      diagnostic_head_severity_1 = '🈲',
      diagnostic_head_severity_2 = '☣️',
      diagnostic_head_severity_3 = '👎',
      diagnostic_head_description = '👹',
      diagnostic_virtual_text = '🦊',
      diagnostic_file = '🚑',
      -- Values
      value_changed = '📝',
      value_definition = '🐶🍡', -- it is easier to see than 🦕
      -- Treesitter
      match_kinds = {
        var = ' ', -- "👹", -- Vampaire
        method = 'ƒ ', --  "🍔", -- mac
        ['function'] = ' ', -- "🤣", -- Fun
        parameter = '  ', -- Pi
        associated = '🤝',
        namespace = '🚀',
        type = ' ',
        field = '🏈',
      },
      treesitter_defult = '🌲',
    },

    debug = true, -- log output - outputs to ~/.cache/nvim/gh.log
    width = 0.62, -- valeu of cols
    height = 0.38, -- listview height
    preview_height = 0.38,
    preview_lines = 40, -- total lines in preview screen
    preview_lines_before = 5, -- lines before the highlight line
    default_mapping = false,
    keymaps = {},
    --keymaps = nav_to_nav(navigator_keymaps), -- e.g keymaps={{key = "GR", func = "references()"}, } this replace gr default mapping
    external = nil, -- true: enable for goneovim multigrid otherwise false

    border = 'single', -- border style, can be one of 'none', 'single', 'double', "shadow"
    lines_show_prompt = 10, -- when the result list items number more than lines_show_prompt,
    -- fuzzy finder prompt will be shown
    combined_attach = 'both', -- both: use both customized attach and navigator default attach, mine: only use my attach defined in vimrc
    on_attach = on_attach,
    ts_fold = false,
    treesitter_analysis = true, -- treesitter variable context
    transparency = nil, -- 0 ~ 100 blur the main window, 100: fully transparent, 0: opaque,  set to nil to disable it
    lsp_signature_help = false, -- if you would like to hook ray-x/lsp_signature plugin in navigator
    -- setup here. if it is nil, navigator will not init signature help
    signature_help_cfg = {
      --debug = true,
      --log_path = vim.fn.stdpath("cache") .. "/lsp_signature.log" -- log dir when debug is on
    }, -- if you would like to init ray-x/lsp_signature plugin in navigator, pass in signature help
    lsp = {
      code_action = {
        enable = true,
        sign = true,
        sign_priority = 40,
        virtual_text = true,
        virtual_text_icon = false,
      },
      code_lens_action = {
        enable = true,
        sign = true,
        sign_priority = 40,
        virtual_text = true,
        virtual_text_icon = false,
      },
      diagnostic = {
        underline = true,
        virtual_text = { spacing = 3, source = true }, -- show virtual for diagnostic message
        update_in_insert = false, -- update diagnostic message in insert mode
        severity_sort = { reverse = true },
      },
      format_on_save = false, -- set to false to disasble lsp code format on save (if you are using prettier/efm/formater etc)
      disable_format_cap = {}, -- a list of lsp disable file format (e.g. if you using efm or vim-codeformat etc), empty by default

      -- disabling a server here will make navigator to not apply its own config to it
      disable_lsp = { "pyright" }, -- a list of lsp server disabled for your project, e.g. denols and tsserver you may

      -- only want to enable one lsp server
      disply_diagnostic_qf = true, -- always show quickfix if there are diagnostic errors
      diagnostic_load_files = false, -- lsp diagnostic errors list may contains uri that not opened yet set to true
      -- to load those files
      diagnostic_virtual_text = true, -- show virtual for diagnostic message
      diagnostic_update_in_insert = false, -- update diagnostic message in insert mode
      diagnostic_scrollbar_sign = { '▃', '▆', '█' }, -- set to nil to disable, set to {'╍', 'ﮆ'} to enable diagnostic status in scroll bar area
      tsserver = {
        -- filetypes = {'typescript'} -- disable javascript etc,
        -- set to {} to disable the lspclient for all filetype
      },
      sumneko_lua = {
        -- sumneko_root_path = sumneko_root_path,
        -- sumneko_binary = sumneko_binary,
        -- cmd = {'lua-language-server'}
      },

      servers = {

        "pyright"



      }, -- you can add additional lsp server so navigator will load the default for you
    },
    lsp_installer = false, -- set to true if you would like use the lsp installed by williamboman/nvim-lsp-installer
  }
)

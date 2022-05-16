local luadev = require("lua-dev").setup({
  library = {
    vimruntime = true, -- runtime path
    types = true, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
    plugins = true, -- installed opt or start plugins in packpath
    -- you can also specify the list of plugins to make available as a workspace library
    -- plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
  },
  -- pass any additional options that will be merged in the final lsp config
  lspconfig = {
    -- cmd = {"lua-language-server"},
    -- on_attach = ...
  },
})
-- https://github.com/neovim/nvim-lspconfig/wiki/UI-customization#go-to-definition-in-a-split-window
local goto_definition = function()
local util = vim.lsp.util
  local log = require("vim.lsp.log")
  local api = vim.api

  -- note, this handler style is for neovim 0.5.1/0.6, if on 0.5, call with function(_, method, result)
  local handler = function(_, result, ctx)
    if result == nil or vim.tbl_isempty(result) then
      local _ = log.info() and log.info(ctx.method, "No location found")
      return nil
    end

    if split_cmd then
      vim.cmd(split_cmd)
    end

    if vim.tbl_islist(result) then
      util.jump_to_location(result[1])

      if #result > 1 then
        util.set_qflist(util.locations_to_items(result))
        api.nvim_command("copen")
        api.nvim_command("wincmd p")
      end
    else
      util.jump_to_location(result)
    end
  end

  return handler
end



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

local on_attach = function(client, bufnr)
  -- https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Avoiding-LSP-formatting-conflicts
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
--vim.lsp.handlers["textDocument/definition"] = goto_definition()


--local lspconfig = require("lspconfig")
--https://github.com/mjlbach/nix-dotfiles/blob/master/home-manager/configs/neovim/init.lua
  
FormatRange = function()
    local start_pos = vim.api.nvim_buf_get_mark(0, "<")
    local end_pos = vim.api.nvim_buf_get_mark(0, ">")
    vim.lsp.buf.range_formatting({}, start_pos, end_pos)
  end
 end
 vim.cmd([[
 command! -range FormatRange  execute 'lua FormatRange()'
 ]])

 vim.cmd([[
 command! Format execute 'lua vim.lsp.buf.formatting()'
 ]])

local luadev = require("lua-dev").setup({
  lspconfig = {
    cmd = { "lua-language-server" },
    settings = {
      Lua = {
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          checkThirdParty = false,
          maxPreload = 100000,
        },
      },
    -- cmd = {"lua-language-server"},
    -- on_attach = ...
  }
  },
})

local servers = {
  -- sumneko_lua = {
  --   cmd = { "lua-language-server" },
  --   settings = {
  --     Lua = {
  --       diagnostics = {
  --         globals = { "vim" },
  --       },
  --       workspace = {
  --         checkThirdParty = false,
  --         maxPreload = 100000,
  --       },
  --     },
  --   },
  -- },
  sumneko_lua = luadev,
  rnix = {},
  bashls = {},
  cssls = {},
  dockerls = {},
  html = {},
  jsonls = {},
  pyright = {},
  tsserver = {},
  vimls = {},
  yamlls = {},
  ember = {},
  clangd = {},
  -- null-ls doesnt have to be added to servers
  --["null-ls"] = {},
  rust_analyzer = {},
}



require("rust-tools").setup()


-- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
--local capabilities = vim.lsp.protocol.make_client_capabilities()
--capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

require("lsp.null-ls").setup()
require("lsp_signature").on_attach(require("lsp.signature"))

for server, config in pairs(servers) do
 
  require"lspconfig"[server].setup(vim.tbl_deep_extend("force", {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    },
  }, config))


vim.api.nvim_buf_set_keymap(0, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', { noremap = true})
  vim.api.nvim_buf_set_keymap(0, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { noremap = true})
  -- buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  -- buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  -- buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  -- buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  -- buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  -- buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  -- buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  -- buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  -- buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  -- buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  -- buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  -- buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  -- buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  -- buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  -- buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

-- suppress lspconfig messages
local notify = vim.notify
vim.notify = function(msg, ...)
  if msg:match("%[lspconfig%]") then
    return
  end
    notify(msg, ...)
  end

end

-- local luadev = require("lua-dev").setup({
--  lspconfig = {
--     cmd = {"lua-language-server"},
--     settings = {
--      Lua = {
--        workspace = {
--          checkThirdParty = false,
--          maxPreload = 100000
--       }
--      }
--     }
--   },
-- })
-- lspconfig.sumneko_lua.setup(luadev)

-- set native lsp signs to troubles default config
-- so other plugins can read them
--vim.fn.sign_define('LightBulbSign', { text = "", texthl = "", linehl="", numhl="" })



local signs = {
  { name = "DiagnosticSignError", text = "" },
  { name = "DiagnosticSignWarn", text = "" },
  { name = "DiagnosticSignHint", text = "" },
  { name = "DiagnosticSignInfo", text = "" },
}
-- trouble
-- error = "",
-- warning = "",
-- hint = "",
-- information = "",
-- other = "﫠",

for _, sign in ipairs(signs) do
  vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end




-- nvim-code-action-menu config
--https://github.com/weilbith/nvim-code-action-menu
--vim.g.code_action_menu_window_border = 'single'
--vim.g.code_action_menu_show_details = false
--vim.g.code_action_menu_show_diff = false


--vim.cmd([[autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()]])

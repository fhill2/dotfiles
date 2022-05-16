-- TODO: could support writing snips  from an empty buffer with a 3rd popup dialog to specify language

local event = require("nui.utils.autocmd").event

local snippy_plug = require("snippy")
local snippy_shared = require("snippy.shared")

local function start_expect_lsp(start, ft)
  local lsp_configs = require("lspconfig.configs")
  --https://github.com/neovim/nvim-lspconfig/blob/master/lua/lspconfig.lua
  local buffer_filetype = ft
  for client_name, config in pairs(lsp_configs) do
    if config.filetypes then
      for _, filetype_match in ipairs(config.filetypes) do
        if buffer_filetype == filetype_match then
          if start then
            dump("autostarted " .. client_name)
            require("lspconfig")[client_name].launch()
          else
            return true
          end
        end
      end
    end
  end
  return false
end

local function get_all_null_ls_filetypes()
  local c = require("null-ls.config")
  --local u = require("null-ls.utils")
  all_null_ft = {}
  for k, v in ipairs(c.get().sources) do
    for kk, vv in ipairs(v.filetypes) do
      if not vim.tbl_contains(all_null_ft, vv) then
        table.insert(all_null_ft, vv)
      end
    end
  end
  return all_null_ft
end

-- ft is optional
local function fix_indentation(visual, filetype)
  local null_ls_client = require"null-ls.client"
  -- create new buffer and format within it
  dump(filetype)
  local bufnr = vim.api.nvim_create_buf(false, false)
  vim.api.nvim_buf_set_option(bufnr, "filetype", filetype)
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, visual)

  vim.api.nvim_buf_call(bufnr, function()
    vim.cmd(("silent w! /tmp/snippy.%s"):format(filetype))
    start_expect_lsp(true, filetype)
  end)
  vim.bo[bufnr].buflisted = false

  local expected_client_amt = 0
  -- check if null-ls is configured to open on the filetype of the current buffer
  if vim.tbl_contains(get_all_null_ls_filetypes(), filetype) then 
    expected_client_amt = expected_client_amt + 1
    -- as lspconfig doesnt start null_ls anymore, and null_ls is rpc, manually attach null_ls to temporary buffer
    null_ls_client.try_add(bufnr)
  end
  --dump(vim.tbl_contains(get_all_null_ls_filetypes(), filetype))

  if start_expect_lsp(false, filetype) then
    expected_client_amt = expected_client_amt + 1
  end
  --dump(start_expect_lsp(false, filetype))

  vim.wait(5000, function()
    -- TODO: maybe add pcall to check and see if null-ls is also being use
    -- atm its expects main lsp and null-ls, so removing null-ls from nvim will make this error
    --dump(expected_client_amt)
    --dump(vim.lsp.buf_get_clients(bufnr))
    return vim.tbl_count(vim.lsp.buf_get_clients(bufnr)) == expected_client_amt
  end, 500, false)

  -- TODO: could add this
  local client_format_capabilities = false
  for _, client in pairs(vim.lsp.buf_get_clients(bufnr)) do
    if client.resolved_capabilities.document_formatting then
      client_format_capabilities = true
    end
  end

  local client_amt = vim.tbl_count(vim.lsp.buf_get_clients(bufnr))

  if client_format_capabilities then
    vim.api.nvim_buf_call(bufnr, function()
      vim.lsp.buf.formatting_sync()
    end)
  else
    vim.api.nvim_err_writeln("DID NOT FORMAT: No client formatting capabilities: attached clients on temporary buffer: " .. client_amt)
  end

  -- add \t to beginning of every line
  local new_visual = vim.tbl_map(function(line)
    return ("\t%s"):format(line)
  end, vim.api.nvim_buf_get_lines(bufnr, 0, -1, false))
  if vim.api.nvim_buf_is_valid(bufnr) then
    vim.cmd(("bwipeout %s"):format(bufnr))
  end
  return new_visual
end

-- copy pasta from snippy nvim

local function save_snippet_to_file(visual, trigger, description, filetype)
  local title
  if not description or description == "" then
    title = ("snippet %s\n"):format(trigger)
  else
    title = ('snippet %s "%s"\n'):format(trigger, description)
  end

  local data = "\n" .. title .. visual
  dump(filetype)
  if filetype == "sh" or filetype == "bash" or filetype == "zsh" then
    filetype = "shell"
  end
    dump(filetype)
  f.append_to_file(("%s/%s.snippets"):format(_G.f.snippet_dirs, filetype), data)

  -- clear snippy cache
  for _, scope in ipairs(snippy_shared.get_scopes()) do
    snippy_shared.cache[scope] = nil
  end
  -- re read snippets from file
  snippy_plug.read_snippets()
end

local snippy = {}

local function get_all_snippet_language_files()
  local scandir = require("plenary.scandir").scan_dir
  local scan_opts = {
    depth = 1,
  }
  return vim.tbl_map(function(fp)
    return fp:gsub(f.snippet_dirs, ""):match("/(.*).snippets$")
  end, scandir(f.snippet_dirs, scan_opts))
end

function snippy.save_snippet()
  local function prompt(visual, filetype)
    local trigger
    local desc_opts = {
      title = "Enter description",
      on_submit = function(description)
        save_snippet_to_file(visual, trigger, description, filetype)
      end,
    }

    f.prompt({
      title = "Enter trigger",
      on_submit = function(value)
        if not value or value == "" then
          value = "_"
        end
        trigger = value
        f.prompt(desc_opts)
      end,
    })
  end

  --if vim.bo.filetype == "" then
  --  f.menu({ items = get_all_snippet_language_files(), on_submit = function(filetype)
  --  local filetype = vim.bo.filetype
  local visual = table.concat(fix_indentation(f.get_visual(), vim.bo.filetype), "\n")
  prompt(visual, vim.bo.filetype)
  --   end})
  -- else
  --   local visual = table.concat(fix_indentation(f.get_visual()), "\n", vim.bo.filetype)
  --   prompt(visual, vim.bo.filetype)
  -- end
end

return snippy

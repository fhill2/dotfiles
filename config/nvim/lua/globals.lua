_G.f = {}
local home = vim.loop.os_homedir()
local rawprint = _G.print
p = function(v)
  rawprint(vim.inspect(v))
  return v
end

pr = function(msg)
  local printoutput = require("util/printoutput")
  printoutput.pr(msg)
end

po = function(msg)
  local printoutput = require("util/printoutput")
  printoutput.po(msg)
end

lo = function(msg)
  local log = require("log1")
  log.info(msg)
  return msg
end

_G.write_sudo = function()
  vim.cmd(("silent w !sudo tee %s"):format(vim.api.nvim_buf_get_name(0)))
end

_G.print_package_path = function()
  for _, v in ipairs(vim.split(package.path, ";")) do
    print(v)
  end
end

_G.print_lsp_config_name = function(name)
  for _, client in pairs(vim.lsp.get_active_clients()) do
    if client.name == name then
      dump(client)
      return
    end
  end
end

-- _G.format_github_repos_dotbot = function()
--   local visual = require("util.visual").get_visual_selection(true)
--   vim.ui.input({ prompt = "Enter subfolder path, e.g: python/evdev" }, function(input)
--     output = {}
--     for i, link in ipairs(visual) do
--       if not vim.startswith(link, "https://github.com") then
--         print("All lines must start with https://github (excluding space): " .. link)
--         return
--       end
--       author, name = link:match("github.com/(.*)/(.*)$")
--       table.insert(output, "~/repos/" .. input .. "/" .. author .. "-" .. name .. ":")
--       table.insert(output, "  url: " .. link)
--     end
--
--     vim.fn.setreg("+", table.concat(output, "\n"))
--     print("DONE - paste output now")
--   end)
-- end

_G.dump = function(...)
  local objects = vim.tbl_map(vim.inspect, { ... })
  require("log").info(unpack(objects))
end
function _G.d(...)
  _G.dump(...)
end

_G.f.prompt = function(...)
  require("plugin.nui.prompt").prompt(...)
end
_G.f.menu = function(...)
  require("plugin.nui.menu").menu(...)
end

_G.paste_code_with_md_code_block = function(range)
  local ft = vim.bo.filetype
  -- called from legendary.nvim
  local visual = require("util.visual").get_visual_selection(false, "\n")
  --local visual = type(visual) == "table" and table.concat(visual, '') or visual
  local visual = [[```]] .. ft .. "\n" .. visual .. "\n```"
  print(vim.inspect(visual))

  vim.fn.setreg("+", visual)
end

_G.f.non_editor_filetypes =
{ "TelescopePrompt", "TelescopeResults", "guihua", "guihua_rust", "clap_input", "NvimTree", "toggleterm" }

function _G.f.send_key(key, mode)
  dump(vim.api.nvim_get_mode().mode)
  local mode = mode or vim.api.nvim_get_mode().mode
  local send = {
    ["esc"] = function(mode)
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), mode, true)
    end,
  }
  send[key](mode)
  if not send[key] then
    vim.api.nvim_errwriteln(key .. "not added to f.send_key yet")
  end
end

-- TODO: use vim.get_marked_region instead of opts.range
function _G.f.get_visual(opts)
  -- lines=true will force the col values to start of line and end of line
  -- range=true returns start end selection values instead of text
  local opts = opts or {}
  -- dont know why this doesnt work on blank ft buffers
  local ft = vim.api.nvim_buf_get_option(0, "filetype")
  if ft == "" or not ft then
    vim.api.nvim_err_writeln("cant use get_visual_selection on buffer with no filetype")
  end

  local mode = vim.fn.mode()
  --if mode == "n" then vim.api.nvim_err_writeln("enter visual mode first") end
  -- if mode ~= "v" or mode ~= "V" or mode ~= "CTRL-V" then
  --   return nil
  -- end

  vim.cmd("w") -- added this for old, otherwise errors
  vim.cmd([[visual!]])
  local _, start_row, start_col, _ = unpack(vim.fn.getpos("'<"))
  local _, end_row, end_col, _ = unpack(vim.fn.getpos("'>"))
  if start_row > end_row or (start_row == end_row and start_col > end_col) then
    start_row, end_row = end_row, start_row
    start_col, end_col = end_col, start_col
  end
  local lines = vim.fn.getline(start_row, end_row)
  local n = 0
  for _ in ipairs(lines) do
    n = n + 1
  end
  if n <= 0 then
    return nil
  end

  if opts.lines then
    -- added fix lines
    start_col = 1
    end_col = #vim.fn.getline(end_row, end_row)[1]
  end

  lines[n] = string.sub(lines[n], 1, end_col)
  lines[1] = string.sub(lines[1], start_col)
  if opts.range then
    return {
      start_col = start_col,
      start_row = start_row,
      end_col = end_col,
      end_row = end_row,
    }
  else
    return lines
  end
end

_G.f.escape_match = function(str)
  -- penlight
  return (str:gsub("[%-%.%+%[%]%(%)%$%^%%%?%*]", "%%%1"))
end

_G.f.reload_current_file = function()
  local reload = require("plenary.reload").reload_module
  local get_project_root = require("util.project_root").get_project_root

  local filepath = vim.fn.expand("%:p")
  local is_plugin = get_project_root(filepath)

  if is_plugin then
    local req = filepath:match("/lua/(.*)/")

    if not req then
      vim.api.nvim_err_writeln("plugin root found: no /lua/ found in filepath, not reloading")
      vim.api.nvim_err_writeln("is_plugin: " .. is_plugin)
      vim.api.nvim_err_writeln("filepath: " .. filepath)
    end
    reload(req, true)
  else
    local req = filepath:match("/lua/(.*)%."):gsub("/", ".")
    if not req then
      vim.api.nvim_err_writeln("no plugin root found: no /lua/ found in filepath, not reloading")
    end
    reload(req)
  end
end

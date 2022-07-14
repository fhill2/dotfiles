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




_G.print_package_path = function()
  for _, v in ipairs(vim.split(package.path, ";")) do
    print(v)
  end
end

_G.print_venv = function()
  for _, client in pairs(vim.lsp.buf_get_clients()) do
    if client.name == "pyright" then
      -- Check if lsp was initialized with py_lsp
      if client.config.settings.python["pythonPath"] == nil then
        print("pyright pythonPath is nil")
      else
        print("Client pyright with venv: " .. client.config.settings.python.pythonPath)
      end
    end
  end
end

_G.print_pyright_config = function()
  for _, client in pairs(vim.lsp.buf_get_clients()) do
    if client.name == "pyright" then
      if client.config.settings.python["pythonPath"] ~= nil then
        dump(client)
      end
    end
  end
end

_G.format_github_repos_dotbot = function()
  local visual = require "util.visual".get_visual_selection(true)
  vim.ui.input(
    { prompt = "Enter subfolder path, e.g: python/evdev" },
    function(input)
      output = {}
      for i, link in ipairs(visual) do
        if not vim.startswith(link, "https://github.com") then
          print("All lines must start with https://github (excluding space): " .. link)
          return
        end
        author, name = link:match("github.com/(.*)/(.*)$")
        table.insert(output, "~/repos/" .. input .. "/" .. author .. "-" .. name .. ":")
        table.insert(output, "  url: " .. link)
      end

      vim.fn.setreg("+", table.concat(output, "\n"))
      print("DONE - paste output now")
    end
  )
end



_G.dump = function(...)
  local objects = vim.tbl_map(vim.inspect, { ... })
  require("log").info(unpack(objects))
end
function _G.d(...)
  _G.dump(...)
end

_G.f.snippet_dirs = home .. "/dev/cl/snippets/snippy" -- snippy save snippets will also change

_G.f.prompt = function(...)
  require("plugin.nui.prompt").prompt(...)
end
_G.f.menu = function(...)
  require("plugin.nui.menu").menu(...)
end

_G.paste_code_with_md_code_block = function(range)
  local ft = vim.bo.filetype
  -- called from legendary.nvim
  local visual = require "util.visual".get_visual_selection(false, '\n')
  --local visual = type(visual) == "table" and table.concat(visual, '') or visual
  local visual = [[```]] .. ft .. '\n' .. visual .. '\n```'
  print(vim.inspect(visual))

  vim.fn.setreg('+', visual)
end

_G.f.non_editor_filetypes = { "TelescopePrompt", "TelescopeResults", "guihua", "guihua_rust", "clap_input", "NvimTree", "toggleterm" }

-- _G.f.list_wins = function(filter_tabpage)
--   -- A BETTER nvim_list_wins() fn -- 2021
--   -- get all opened filepaths in windows with their associated bufnr with key as winnr
--   -- ignores nvim-tree, toggleterm etc. editor windows returned only
--   -- optional: returns each table sorted by position on the screen top left - bot right
--
--   local ignore = { "NvimTree", "toggleterm" }
--
--   local ctabpage
--   if filter_tabpage then
--     ctabpage = vim.api.nvim_get_current_tabpage()
--   end
--
--   local windows = {}
--   for _, win in ipairs(vim.api.nvim_list_wins()) do
--     dump("ITERATE ON " .. win)
--     local bufnr = vim.api.nvim_win_get_buf(win)
--     local window = {}
--
--     window.tabpage = vim.api.nvim_win_get_tabpage(win)
--     if filter_tabpage and window.tabpage ~= ctabpage then
--       break
--     end
--     window.ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
--     window.winnr = win
--     window.fp = vim.api.nvim_buf_get_name(bufnr)
--     window.bufnr = bufnr
--     local pos = vim.api.nvim_win_get_position(win)
--     window.x = pos[2]
--     window.y = pos[1]
--
--     if not vim.tbl_contains(ignore, window.ft) then
--       table.insert(windows, window)
--     end
--   end
--
--   table.sort(windows, function(a, b)
--     if a.x ~= b.x then
--       return a.x < b.x
--     end
--     return a.y < b.y
--   end)
--   return windows
--
--   -- cb() tests:
--   -- exclusive to current tabpage:
-- end

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

_G.f.append_to_file = function(fp, data)
  local Path = require("plenary.path")
  local fp = Path:new(fp)
  -- plenary path write creates new file if file doesnt exist yet
  fp:write(data, "a")
end

_G.f.enter_insert = function()
  local mode = vim.api.nvim_get_mode().mode

  if mode == "n" then
    vim.api.nvim_feedkeys("i", "n", false)
  end
end

_G.f.get_filename = function(fp)
  return fp:match("^.+/(.+)$")
end

_G.f.parent = function(fp)
  -- ~/dev/cl/file.py --> ~/dev/cl
  return fp:match("^(.*)/")
end
-- check if all folders in a filepath exist. if not, create them
-- only works for folders in current user folder
_G.f.create_fp_dirs = function(...)
  require("util.fs").create_fp_dirs(...)
end

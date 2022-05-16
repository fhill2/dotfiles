local action_state = require("telescope.actions.state")
local entry = action_state.get_selected_entry
local action_utils = require("telescope.actions.utils")
local actions = require("telescope.actions")
local uv = vim.loop

local function fp()
  local entry = entry()
  return ("%s/%s"):format(entry.cwd, entry[1])
end


local function dropdown_out(data)
  --if uv.fs_stat("/tmp/dropdown") then uv.fs_unlink("/tmp/dropdown") end
  -- require"util.fs".create_file({
  -- dest = "/tmp/dropdown",
  -- force = true,
  -- silent = false,
  -- })
-- WRITE TO FILE HERE
require"util.fs".write("/tmp/dropdown", data)
end


local function close_or_exit(prompt_bufnr, data)
  -- if dropdown, exit nvim
  if dropdown_profile then
    if prompt_bufnr then actions.close(prompt_bufnr) end
    dropdown_out(data)
    vim.cmd("silent qa!")
  else
    actions.close(prompt_bufnr)
  end
end



local A = {}

function A.move_previewer_window(prompt_bufnr)
  local picker = action_state.get_current_picker(prompt_bufnr)
end

local function cd(dir)
  if uv.fs_stat(dir) then
    vim.api.nvim_set_current_dir(dir)
    print("cd into: " .. dir)
  else
    vim.api.nvim_err_writeln(dir .. " doesnt exist")
  end
end

function A.dropdown_exit(prompt_bufnr)
  if not dropdown_profile then vim.api.nvim_err_writeln("not in dropdown profile, doing nothing") return end
local entry = entry()
close_or_exit(prompt_bufnr, entry.value)
end

function A.cd(prompt_bufnr)
  local entry = entry()
  entry.value = entry.value:match(entry.cwd) and entry.value or fp()
  cd(entry.value)
  close_or_exit(prompt_bufnr, entry.value)
end

function A.cd_value(prompt_bufnr)
  local entry = entry()
  cd(entry.value)
  close_or_exit(prompt_bufnr, entry.value)
end

function A.find_files(prompt_bufnr)
  require("telescope.builtin").find_files({ cwd = fp() })
end

function A.live_grep(prompt_bufnr)
  require("telescope.builtin").live_grep({ cwd = fp() })
end

function A.create_note(prompt_bufnr)
  close_or_exit(prompt_bufnr)
  require("util.fs").create_file_prompt({
    dest = fp(),
    ext = "norg",
  })
end


-- from telescope/actions/set.lua
-- main edit function. added here because newer telescope version errors when opening/editing a file in a different cwd


local edit_buffer
do
  local map = {
    edit = "buffer",
    new = "sbuffer",
    vnew = "vert sbuffer",
    tabedit = "tab sb",
  }

  edit_buffer = function(command, bufnr)
    command = map[command]
    if command == nil then
      error "There was no associated buffer command"
    end
    vim.cmd(string.format("%s %d", command, bufnr))
  end
end


function A.edit(prompt_bufnr, fp)
  close_or_exit(prompt_bufnr)
  --vim.api.nvim_set_current_buf(prompt_bufnr)
  vim.cmd("edit!" .. fp)
end


--function A.edit(prompt_bufnr, command)
 
  -- // telescope default edit
--   local entry = action_state.get_selected_entry()
-- dump(entry)
--   if not entry then
--     print "[telescope] Nothing currently selected"
--     return
--   end

--   local filename, row, col

--   if entry.path or entry.filename then
--     filename = entry.path or entry.filename

--     -- TODO: Check for off-by-one
--     row = entry.row or entry.lnum
--     col = entry.col
--   elseif not entry.bufnr then
--     -- TODO: Might want to remove this and force people
--     -- to put stuff into `filename`
--     local value = entry.value
--     if not value then
--       print "Could not do anything with blank line..."
--       return
--     end

--     if type(value) == "table" then
--       value = entry.display
--     end

--     local sections = vim.split(value, ":")

--     filename = sections[1]
--     row = tonumber(sections[2])
--     col = tonumber(sections[3])
--   end

--   local entry_bufnr = entry.bufnr

--   require("telescope.actions").close(prompt_bufnr)

--   if entry_bufnr then
--     edit_buffer(command, entry_bufnr)
--   else
    -- check if we didn't pick a different buffer
    -- prevents restarting lsp server
--     if vim.api.nvim_buf_get_name(0) ~= filename or command ~= "edit" then
--       filename = Path:new(vim.fn.fnameescape(filename)):normalize(vim.loop.cwd())
--       pcall(vim.cmd, string.format("%s %s", command, filename))
--     end
--   end

--   if row and col then
--     local ok, err_msg = pcall(a.nvim_win_set_cursor, 0, { row, col })
--     if not ok then
--       log.debug("Failed to move to cursor:", err_msg, row, col)
--     end
--   end
-- end


return A

----

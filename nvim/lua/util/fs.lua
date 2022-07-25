local uv = vim.loop
local fs = {}
-- a lot of this is from nvim-tree

-- function fs.scandir(cwd)
--   print("function asdasdcalled")
-- -- because I can't get plenary scandir to see symlinks

--  local handle = uv.fs_scandir(cwd)
--   if type(handle) == 'string' then
--     vim.api.nvim_err_writeln(handle)
--     return
--   end

--   local dirs = {}
--   local links = {}
--   local files = {}

--   while true do
--     local name, t = uv.fs_scandir_next(handle)
--     print(name)
--     if not name then break end

--     local abs = utils.path_join({cwd, name})
--     --if not should_ignore(abs) then
--       if not t then
--         local stat = uv.fs_stat(abs)
--         t = stat and stat.type
--        end

--       if t == 'directory' then
--         table.insert(dirs, name)
--       elseif t == 'file' then
--         table.insert(files, name)
--       elseif t == 'link' then
--         table.insert(links, name)
--       end
--     --end
--   end
--   dump(dirs)
--   dump(links)
--   dump(files)
-- end

local function process_item(opts, name, type, current_dir, next_dir, data)
  if type == "directory" or "link" then
    local fp = current_dir .. "/" .. name
    if opts.on_insert(fp, type) then
      table.insert(next_dir, fp)
      table.insert(data, fp)
    end
  end
end

function fs.scandir(path, opts)
  if not opts.on_insert then
    vim.api.nvim_err_writeln("on_insert cb is needed")
  end
  -- simplified modified scandir with support for symlinks and customized on_insert
  opts = opts or {}

  local data = {}
  local base_paths = vim.tbl_flatten({ path })
  local next_dir = vim.tbl_flatten({ path })

  --local gitignore = opts.respect_gitignore and make_gitignore(base_paths) or nil
  --local match_search_pat = opts.search_pattern and gen_search_pat(opts.search_pattern) or nil

  -- for i = table.getn(base_paths), 1, -1 do
  --   if uv.fs_access(base_paths[i], "X") == false then
  --     if not F.if_nil(opts.silent, false, opts.silent) then
  --       print(string.format("%s is not accessible by the current user!", base_paths[i]))
  --     end
  --     table.remove(base_paths, i)
  --   end
  -- end
  if table.getn(base_paths) == 0 then
    return {}
  end

  repeat
    local current_dir = table.remove(next_dir, 1)
    local fd = uv.fs_scandir(current_dir)
    if fd then
      while true do
        local name, type = uv.fs_scandir_next(fd)
        if name == nil then
          break
        end
        process_item(opts, name, type, current_dir, next_dir, data)
      end
    end
  until table.getn(next_dir) == 0
  return data
end

function fs.trash() end

function fs.trash_current_file()
  local filename = vim.fn.expand("%:t")
  local filepath = vim.fn.expand("%:p")
  uv.fs_rename(filepath, f.home .. "/.local/share/Trash/files/" .. filename)
  vim.cmd("Bdelete! " .. vim.api.nvim_get_current_buf())
end

-- function fs.create_template(opts)
--   -- not using
--   dump("create template called")
--   -- dest
--   -- template --> filename in templates folder (source)
--   local template_dir = ("%s/templates"):format(f.dev_cl)
--   if not uv.fs_stat(template_dir) then
--     vim.api.nvim_err_writeln("cant find templates folder")
--     return
--   end
--   if not opts.dest then
--     vim.api.nvim_err_writeln("specify opt.dest")
--     return
--   end
--
--   local on_submit = function(value)
--     local filename = value
--     -- copy default template file, then rename to input given name, then load file
--     local dest = ("%s/%s"):format(opts.dest, filename)
--     local source = ("%s/%s"):format(template_dir, opts.template)
--     fs.copy_file({
--       source = source,
--       dest = dest,
--     })
--   end
--
--   f.prompt({
--     title = ("create File from Template - %s/x"):format(opts.dest),
--     on_submit = on_submit,
--   })
-- end
--
-- function fs.create_file_prompt(opts)
--   local opts = opts or {}
--   f.prompt({
--     title = ("create File - %s/x"):format(opts.dest),
--     on_submit = function(value)
--       fs.create_file({
--         dest = ("%s/%s"):format(opts.dest, value),
--         ext = opts.ext,
--         open = true,
--       })
--     end,
--   })
-- end

--https://github.com/kyazdani42/nvim-tree.lua/blob/ec3f10e2116f344d9cc5c9980bddf7819f27d8ae/lua/nvim-tree/fs.lua#L22
-- function fs.create_file(opts)
--   -- dest
--   -- ext = force file to be this extension
--   -- force = disables prompting if file exists - will overrwrite
--   -- silent = no print
--   -- creates a BLANK file
--   -- fs.write also creates a blank file and writes to it
--   local opts = opts or {}
--
--   -- make sure ext always has .
--   if opts.ext and not opts.ext:match("%.") then
--     opts.ext = "." .. opts.ext
--   end
--   -- if I didnt specify an extension, use the overridable extension
--   -- if I specify another extension, use mine
--   if not f.get_filename(opts.dest):match("%.") and opts.ext then
--     opts.dest = opts.dest .. opts.ext
--   end
--
--   if not opts.force and uv.fs_access(opts.dest, "r") ~= false then
--     local utils = require("nvim-tree.utils")
--     print(file .. " already exists. Overwrite? y/n")
--     local ans = utils.get_user_input_char()
--     utils.clear_prompt()
--     if ans ~= "y" then
--       return
--     end
--   end
--
--
--   uv.fs_open(
--     opts.dest,
--     "w",
--     420,
--     vim.schedule_wrap(function(err, fd)
--       if err then
--         vim.api.nvim_err_writeln("Couldn't create file " .. file)
--       else
--         if not opts.silent then print(opts.dest .. " - successfully created") end
--         uv.fs_close(fd)
--       end
--     end)
--   )
--   if opts.open then vim.cmd(("e %s"):format(opts.dest)) end
-- end

-- function fs.copy_file(opts)
--   local opts = opts or {}
--   -- copy existing file
--   local parent_exists = uv.fs_stat(f.parent(opts.dest))
--   local source_exists = uv.fs_stat(opts.source).type == "file"
--   local dest_exists = uv.fs_stat(opts.dest).type == "file"
--
--   if not parent_exists then
--     fs.create_fp_dirs(opts.dest)
--   end
--
--   if dest_exists then
--     vim.api.nvim_err_writeln(opts.dest .. " - already Exists")
--     return
--   end
--
--   if source_exists then
--     uv.fs_copyfile(opts.source, opts.dest, nil, function(err, success)
--       if err then
--         vim.api.nvim_err_writeln(err)
--         return
--       else
--         print(success)
--         print(("template %s copied to %s"):format(opts.template, opts.dest))
--       end
--     end)
--   else
--     vim.api.nvim_err_writeln(opts.source .. "doesn't exist")
--     return
--   end
-- end

function fs.create_fp_dirs(fp)
  local uv = vim.loop

  local home = uv.os_homedir()

  if fp:find(home) then
    _, _, fp = fp:find(home .. "/(.*)")
  end

  local dirs_to_create = {}

  local fp = vim.split(fp, "/")
  local file_or_dir = fp[#fp]:find("%.")
  if file_or_dir then
    table.remove(fp, #fp)
  end
  local depth = #fp
  local current_relpath = fp[1]
  for i = 1, depth do
    table.insert(dirs_to_create, string.format("%s/%s", home, current_relpath))
    current_relpath = current_relpath .. "/" .. (fp[i + 1] or "")
  end

  for i, folderpath in ipairs(dirs_to_create) do
    local mode = uv.fs_stat(home).mode

    local r = uv.fs_stat(folderpath, nil)
    if r == nil then
      local r = uv.fs_mkdir(folderpath, mode, nil)
      if r == nil then
        assert(false, "couldnt write to file " .. folderpath)
      end
    end
  end
end

--- ===== WRITES ======
--https://github.com/nvim-telescope/telescope.nvim/blob/master/lua/telescope/actions/history.lua

-- local write_async = function(path, txt, flag)
--   uv.fs_open(path, flag, 438, function(open_err, fd)
--     assert(not open_err, open_err)
--     uv.fs_write(fd, txt, -1, function(write_err)
--       assert(not write_err, write_err)
--       uv.fs_close(fd, function(close_err)
--         assert(not close_err, close_err)
--       end)
--     end)
--   end)
-- end

-- local append_async = function(path, txt)
--   write_async(path, txt, "a")
-- end

function fs.append(fp, data)
  local Path = require("plenary.path")
  local fp = Path:new(fp)
  -- plenary path write creates new file if file doesnt exist yet
  fp:write(data, "a")
end

function fs.write(fp, data)
  dump(fp, data)
  local Path = require("plenary.path")
  local fp = Path:new(fp)
  fp:write(data, "w")
end

return fs

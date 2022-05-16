local M = {}

-- vim.fn.setqflist({
--   {bufnr = bufnr, lnum = 1, col = 5}, {bufnr = bufnr, lnum = 2, col = 10},
--   {bufnr = bufnr, lnum = 3, col = 13, text = "asdasdasd"}
-- })

-- local traceback = {
--   [[Traceback (most recent call last):]],
--   [[File "/home/f1/dev/cl/python/scratch/sniprun.py", line 8, in <module>]],
--   [[hello(1,2)]],
--   [[File "/home/f1/dev/cl/python/scratch/sniprun.py", line 4, in hello:]],
--   [[return j]],
--   [[NameError: name 'j' is not defined]],
-- }

local ft = vim.api.nvim_buf_get_option(vim.api.nvim_get_current_buf(), "filetype")

local jobs_parsers = require("util.run.jobs_parsers")
local jobs = jobs_parsers.jobs
local parsers = jobs_parsers.parsers

function M.run_qtile()
  --M.run(([[zsh -c 'nc localhost 7113 < %s']]):format(vim.api.nvim_buf_get_name(0)), "qtile")
  M.run({
    cmd = { "zsh", "-c", ("nc localhost 7113 < %s"):format(vim.api.nvim_buf_get_name(0)) },
    parser = "qtile",
  })
end

-- local function finish(output, parse)
--   -- when the job finishes
--   local entries = parse(output.message)

--   if debug then
--     dump("Output message: ")
--     dump(output.message)
--     dump("Entries: ")
--     dump(entries)
--   end

--   vim.fn.setqflist(entries)
--   dump("got to copen")
--   vim.cmd("copen")
-- end



local function get_locked_parser(parser)
  dump("locked parser")
    return 
    "default" and parsers.default or 
    "ft_default" and parsers[ft].default or
    parsers[ft][parser]
end

local function get_parser(opts)
  if not parsers[ft] then
    return parsers.default
  end

  local default_parser = parsers.default
  local default_ft_parser = parsers[ft].default
  local selected_parser = parsers[ft][opts.parser]

  return selected_parser or default_ft_parser or default_parser
end

local function get_job(opts)
  local default_job = jobs.default
  local selected_job = jobs[opts.job]

  return selected_job or default_job
end

local function def_cmd(opts)
  return ({
    --python = vim.cmd([[AsyncRun python "$(VIM_FILEPATH)"]]),
    python = { "/usr/bin/python", vim.api.nvim_buf_get_name(0) },
    cpp = {"/usr/bin/zsh", "-c", ("/usr/bin/g++ %s && ./a.out"):format(vim.api.nvim_buf_get_name(0)) },
    --lua = "luafile %",
    --vim = "source %",
  })[ft] or "cmd for " .. ft .. " not listed in default cmd table"
end


function M.lock_parser(parser) 
  lock_parser = get_locked_parser(parser)
end

function M.unlock_parser()
  lock_parser = nil
end


function M.run(opts)
  dump("===== NEW RUN =====")
  local opts = opts or {}

  dump(lock_parser)
  opts.parser = lock_parser or get_parser(opts)
  assert(type(opts.parser) == "function", "failed to get parser")


  opts.job = get_job(opts)
  assert(type(opts.job) == "function", "failed to get job")

  if not opts.cmd then
    opts.cmd = def_cmd()
  end
  assert(type(opts.cmd) == "table", "opts.cmd = table")

  jobs_parsers.refresh()
  opts.job({ cmd = opts.cmd, parser = opts.parser })
end

return M

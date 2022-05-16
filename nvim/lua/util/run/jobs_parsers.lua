local debug = false
local dont_focus = true

local function debug(...)
  if debug then
    dump(...)
  end
end

local function trim(s)
  local s = s:gsub("^%s+", ""):gsub("%s+$", "")
  return s
end


function refresh()
-- sets global scope for all functions, everytime a job is run
refresh = true
bufnr = vim.api.nvim_get_current_buf()
winnr = vim.api.nvim_get_current_win()
vim.fn.setqflist({{}, 'r', { items = {}}})
end


local function setqflist(entry)
  if refresh then 
    dump("refreshed")
  vim.cmd("copen")
  refresh = false
  end


  vim.fn.setqflist({}, "a", { items = { entry } })
  vim.cmd("clast")
  if dont_focus then vim.api.nvim_set_current_win(winnr) end
end

-- ====================== PARSERS ========================
local parsers = { python = {} }

parsers.default = function(line)
  setqflist({ text = line })
end

parsers.python.default = function(line)
  if prev_line then
    local linenr = prev_line:match(", line%s(%d+),")
    setqflist({
      bufnr = bufnr,

      text = prev_line
      :gsub(", line%s%d+,", ""):gsub("^File", "") 
      .. " --> " .. line,
      lnum = tonumber(linenr),
    })
    prev_line = nil
    return
  end

  if line:match("^File") then
    prev_line = line
    return
  end

  setqflist({ text = line })
end

parsers.python.qtile = function(line)
local line = line:gsub(">>>", ""):gsub("%.%.%.", ""):gsub("%s%s", " ")
if line:match("%a") then
setqflist({ text = trim(line) })
end
end

-- ====================== JOBS ========================

local function output(opts, line)
  if type(line) == "table" then
    for _, v in ipairs(line) do
      if v == "" then
        return
      end
      opts.parser(trim(v))
    end
  elseif type(line) == "string" then
    if line == "" then
      return
    end
    opts.parser(trim(line))
  end
end

local jobs = {}
jobs.default = function(opts)
  vim.fn.jobstart(opts.cmd, {
    on_exit = function(_, err) end,
    on_stdout = function(_, line)
      output(opts, line)
    end,

    on_stderr = function(_, line)
      output(opts, line)
    end,
  })
end

return {
  refresh = refresh,
  jobs = jobs,
  parsers = parsers,
}



local M = {}

M.parse = function(config, cfp, cft)

local old = {
  cfp = cfp,
  --filename = vim.fn.expand("%"), 
  ft = cft,
  -- rel
  -- split_at -- furthest most match found
}


local is_shell = vim.tbl_contains({ "sh", "zsh"}, cft)
if is_shell then old.ft = "shell" end
-- TODO: parse_filepath -- for files with no extension, or for files I want under multiple group, could check filepath for string




local function reverse_match(s, m)
  -- finds last occurence of word/match phrase in string
  -- returns 1:bool, 2: end character of last occurence of word/match phrase in string
  local rev_s = s:reverse()
  local rev_m = f.escape_match((m):reverse())
  local rev_r = rev_s:find(rev_m)
  if rev_r then
    return true, #s - rev_r - #m + 2
  else
    return false
  end
end

local match_list = {}
vim.list_extend(match_list, config.all)
if config.filetype[old.ft] then
  vim.list_extend(match_list, config.filetype[old.ft])
end

local match_amt = 0
local match
local split_at
for _, single_match_list in ipairs(match_list) do -- FOR LOOP LUA
  local nested_match_amt = 0
  vim.tbl_map(function(single_match) -- EACH ITEM IN MATCHES
    local matched, pos = reverse_match(old.cfp, single_match)
    if matched and not split_at then
      split_at = pos
    elseif matched and split_at then
      if pos > split_at then
        split_at = pos
      end
    end
    if matched then
      nested_match_amt = nested_match_amt + 1
    end
  end, single_match_list[1]) -- END EACH ITEM IN MATCHES

  if nested_match_amt == #single_match_list[1] then
    match_amt = match_amt + 1
    match = single_match_list
  end
end -- END FOR LOOP LUA

if match_amt == 1 then
  old.relpath = old.cfp:sub(split_at, -1)
  -- build old path
  if match.transform then
    old.oldpath = match.transform(old)
    if not old.oldpath then vim.api.nvim_err_writeln("transform function didnt return anything") return end
  else
    old.oldpath = ("%s/%s/%s"):format(f.old, old.ft, old.relpath)
  end
  old.oldpath = old.oldpath:gsub("//", "/")
  return old.oldpath
elseif match_amt > 1 then
  vim.api.nvim_err_writeln("ERROR STOPPING: MULTIPLE MATCHES FOUND FOR FILETYPE" .. old.ft .. " - " .. old.cfp)
elseif match_amt == 0 then
  vim.api.nvim_err_writeln("ERROR STOPPING: MATCH NOT FOUND FOR FILETYPE: " .. old.ft .. " - " .. old.cfp)
end

end
return M
-- TESTS
--local cfp = "/home/f1/dev/me-plug/cl/lua/me-plug/codelibrary-lua/ln.lua"
--local cfp = "/home/f1/dev/cl/lua/me-plug/floating.nvim/lua/floating.lua"
--local cfp = "/home/f1/dev/cl/lua/me-plug/floating.nvim/lua/floating/utils.lua"

--local cfp = "/home/f1/dev/cl/lua/fork-plug/nvim-snippy/lua/snippy.lua"
--local cfp = "/home/f1/dev/cl/lua/fork-plug/nvim-snippy/lua/snippy/util.lua"

--local cfp = "/home/f1/dev/dot/home-manager/config/nvim/lua/globals"
--local cfp = "/home/f1/dev/dot/home-manager/config/nvim/lua/nvim-main-init.lua"

-- awesome
--local cfp = "/home/f1/dev/dot/home-manager/config/awesome/main/helpers.lua"
--local cfp = "/home/f1/dev/dot/home-manager/config/awesome/rc.lua"

-- vim
--local cfp = "/home/f1/dev/dot/home-manager/config/nvim/ginit.vim"
--local cfp = "/home/f1/dev/dot/home-manager/config/nvim/after/plugin/futil.vim"

-- nix
--local cfp = "/home/f1/dev/dot/home-manager/flake.nix"
--local cfp = "/home/f1/dev/dot/system/flake.nix"

-- no filetype
--local cfp = "/home/f1/dev/dot/home-manager/config/.zshrc"

-- unmatched
--local cfp = "/home/f1/Desktop/lsp-init-old.lua"

-- other testers
--local cfp = "/home/f1/dev/me-plug/cl/lua/me-plug/codelibrary-lua/butterasdasdasdasdasdln.lua"

local config = require("project_nvim.config")
local glob = require("project_nvim.utils.globtopattern")
local path = require("project_nvim.utils.path")
local uv = vim.loop

local M = {}
--https://github.com/ahmedkhalf/project.nvim
function M.get_project_root(search_dir)
	--local search_dir = vim.fn.expand("%:p:h", true)
	if vim.fn.has("win32") > 0 then
		search_dir = search_dir:gsub("\\", "/")
	end

	local last_dir_cache = ""
	local curr_dir_cache = {}

	local function get_parent(path)
		path = path:match("^(.*)/")
		if path == "" then
			path = "/"
		end
		return path
	end

	local function get_files(file_dir)
		last_dir_cache = file_dir
		curr_dir_cache = {}

		local dir = uv.fs_scandir(file_dir)
		if dir == nil then
			return
		end

		while true do
			local file = uv.fs_scandir_next(dir)
			if file == nil then
				return
			end

			table.insert(curr_dir_cache, file)
		end
	end

	local function is(dir, identifier)
		dir = dir:match(".*/(.*)")
		return dir == identifier
	end

	local function sub(dir, identifier)
		local path = get_parent(dir)
		while true do
			if is(path, identifier) then
				return true
			end
			local current = path
			path = get_parent(path)
			if current == path then
				return false
			end
		end
	end

	local function child(dir, identifier)
		local path = get_parent(dir)
		return is(path, identifier)
	end

	local function has(dir, identifier)
		if last_dir_cache ~= dir then
			get_files(dir)
		end
		local pattern = glob.globtopattern(identifier)
		for _, file in ipairs(curr_dir_cache) do
			if file:match(pattern) ~= nil then
				return true
			end
		end
		return false
	end

	local function match(dir, pattern)
		local first_char = pattern:sub(1, 1)
		if first_char == "=" then
			return is(dir, pattern:sub(2))
		elseif first_char == "^" then
			return sub(dir, pattern:sub(2))
		elseif first_char == ">" then
			return child(dir, pattern:sub(2))
		else
			return has(dir, pattern)
		end
	end

	-- breadth-first search
	while true do
		for _, pattern in ipairs({ ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" }) do
			--for _, pattern in ipairs(config.options.patterns) do
			local exclude = false
			if pattern:sub(1, 1) == "!" then
				exclude = true
				pattern = pattern:sub(2)
			end
			if match(search_dir, pattern) then
				if exclude then
					break
				else
					return search_dir, "pattern " .. pattern
				end
			end
		end

		local parent = get_parent(search_dir)
		if parent == search_dir or parent == nil then
			return nil
		end

		search_dir = parent
	end
end
return M

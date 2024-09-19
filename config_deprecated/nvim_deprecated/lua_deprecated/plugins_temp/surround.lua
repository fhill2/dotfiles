-- default configuration is here:
-- https://github.com/kylechui/nvim-surround/blob/main/lua/nvim-surround/config.lua

local get_delete_line_above = function()
	-- jump to line above, delete into blackhole register, line below
	local rownr = vim.api.nvim_win_get_cursor(0)[1]
	local line = vim.api.nvim_buf_get_lines(0, rownr - 2, rownr - 1, false)[1] -- line above as string
	vim.api.nvim_feedkeys('k"_ddj', "n", false)
	return line
end

require("nvim-surround").setup({
	surrounds = {
		["L"] = {
			add = function()
				line_above = get_delete_line_above()
				return {
					{ "[" .. line_above .. "](" },
					{ ")" },
				}
			end,
			find = "%b[]%b()",
			delete = "^(%[)().-(%]%b())()$",
			change = {
				target = "^()()%b[]%((.-)()%)$",
				replacement = function()
					line_above = get_delete_line_above()
					return {
						{ "" },
						{ line_above },
					}
				end,
			},
		},
		["l"] = {
			add = function()
				return {
					{ "[](" },
					{ ")" },
				}
			end,

			find = "%b[]%b()",
			delete = "^(%[)().-(%]%b())()$",
			change = {
				target = "^()()%b[]%((.-)()%)$",
				replacement = function()
					local clipboard = vim.fn.getreg("+"):gsub("\n", "")
					return {
						{ "" },
						{ clipboard },
					}
				end,
			},
		},
	},
})

-- require("nvim-surround").buffer_setup({
--     delimiters = {
--         pairs = {
--             ["l"] = { "[", "]()" },
--             ["L"] = { "[](", ")" },
--         },
--     },
-- })

local layout_strats = require("telescope.pickers.layout_strategies")
layout_strats.horizontal_nonfloat = function(self, max_columns, max_lines)
	-- local args = table.pack(...)

	-- for i = 1, args.n do
	--   dump("DUMPING: " .. i)
	--   dump(args[i])
	-- end
	-- dump("HORIZNTAL NONFLOAT LAYOUT STRAT")
	-- dump(self.previewer)
	dump(self.previewer._title_fn())
	-- dump(layout_config)
	dump(self.layout_config)
	if self.previewer._title_fn() == "nonFloat Previewer" then
		-- self.previewer = nil
		dump("nonFloat RETURNED")
		-- dump(layout_strats.horizontal(self, max_columns, max_lines, self.layout_config))
		return {
			-- preview = {
			--   border = true,
			--   -- borderchars = <1>{ "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
			--   col = 244,
			--   enter = false,
			--   height = 14,
			--   highlight = false,
			--   line = 26,
			--   title = "nonFloat Previewer",
			--   width = 120
			-- },
			prompt = {
				border = true,
				-- borderchars = <table 1>,
				col = 21,
				enter = true,
				height = 1,
				line = 39,
				title = "Find Files",
				width = 221,
			},
			results = {
				border = true,
				-- borderchars = <table 1>,
				col = 21,
				enter = false,
				height = 11,
				line = 26,
				title = "Results",
				width = 221,
			},
		}
	else
		dump("NORMAL HORIZONTAL RETURNED")
		return layout_strats.horizontal(self, max_columns, max_lines, self.layout_config)
	end
end

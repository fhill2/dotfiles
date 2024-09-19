local conf = require("telescope.config").values
local sorters = require("telescope.sorters")
local my_sorters = {}
my_sorters.frecency_sorter = function(opts)
	opts = opts or {}
	local fuzzy_sorter = conf.file_sorter(opts)

	return sorters.Sorter:new({
		init = function(self)
			self.sortby = opts.sortby
		end,
		-- cb_add = function(entry, score)
		--   entry.score = score
		-- end,
		scoring_function = function(self, prompt, line, entry, cb_add, cb_filter)
			-- lower returned score is better - puts the result closer to the top/default selection
			local base_score = fuzzy_sorter:scoring_function(prompt, line, cb_add, cb_filter)

			if base_score == -1 then
				return -1
			end

			if self.sortby == "fuzzy" then
				return base_score
			end

			if self.sortby == "date" then
				return math.pow(entry.mtime, -1) -- mtime = number
			end

			if self.sortby == "rank" then -- frecency or zoxide
				-- in sortby rank - ranked values have no effect on fuzzy scored values, ranked are always ranked lowest/highest
				-- if no frecency rank, then return generic fuzzy sorter score
				-- as fuzzy scores can get close to 0, make sure the maximum / highest scores stays above 1
				if entry.rank == 0 then
					return base_score + 1
				end
				-- lowest frecency rank possible is 1,
				-- +1 to make sure math.pow() outputs ~0.5 as the max value or lowest frecency score
				-- higher frecency scores will output lower math.pow() scores
				if entry.rank > 0 then
					return math.pow(entry.rank + 1, -1)
				end
			end

			if self.sortby == "fuzzy+rank" then
				-- divide by 1 to invert score as lower is better
				-- +1 so rank values of 0 are correctly treated the same other values
				-- decrease 0.01 to decrease the weight of rank on the final score
				local rank = math.pow(1 / (entry.rank + 0.5), 0.005)
				local score = base_score + rank
				return score
			end
		end,
		--highlighter = fuzzy_sorter.highlighter
		highlighter = fuzzy_sorter.highlighter,
	})
end

-- my_sorters.fb_sorter = function(opts)
--
--   return sorters.Sorter:new({
--
--     scoring_function = function(self, prompt, line, entry, cb_add, cb_filter)
--       dump(entry.stat)
--     end
--   })
-- end
--
return my_sorters

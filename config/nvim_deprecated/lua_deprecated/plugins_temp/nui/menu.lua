local M = {}
----
M.menu = vim.schedule_wrap(function(opts)
	local Menu = require("nui.menu")
	local event = require("nui.utils.autocmd").event
	local opts = opts or {}

	local items = {}
	for k, v in ipairs(opts.items) do
		table.insert(items, Menu.item(v))
	end

	f.send_key("esc")

	local result
	local menu = Menu({
		position = "50%",
		size = {
			width = 30,
			height = #opts.items,
		},
		relative = "editor",
		border = {
			style = "single",
			text = {
				top = "Choose Language Snippet File",
				top_align = "center",
			},
		},
		win_options = {
			winblend = 10,
			winhighlight = "Normal:Normal",
		},
	}, {
		-- lines = {
		--   Menu.item("Item 1"),
		--   Menu.item("Item 2"),
		--   Menu.separator("Menu Group", {
		--     char = "-",
		--     text_align = "right",
		--   }),
		--   Menu.item("Item 3"),
		-- },
		lines = items,
		max_width = 20,
		keymap = {
			focus_next = { "j", "<Down>", "<Tab>" },
			focus_prev = { "k", "<Up>", "<S-Tab>" },
			close = { "<Esc>", "<C-c>" },
			submit = { "<CR>", "<Space>" },
		},
		on_close = function()
			--print("CLOSED")
		end,
		on_submit = function(item)
			if opts.on_submit then
				opts.on_submit(item)
			end
			--print("SUBMITTED", vim.inspect(item))
		end,
	})

	-- mount the component
	menu:mount()

	menu:on(event.BufLeave, menu.menu_props.on_close, { once = true })
end)
return M

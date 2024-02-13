local npairs = require("nvim-autopairs")

npairs.setup({
	disable_filetype = { "TelescopePrompt", "guihua", "guihua_rust", "clap_input" },
	fast_wrap = {
		map = "<leader>i",
		chars = { "{", "[", "(", '"', "'" },
		pattern = [=[[%'%"%)%>%]%)%}%,]]=],
		end_key = "$",
		keys = "qwertyuiopzxcvbnmasdfghjkl",
		check_comma = true,
		highlight = "Search",
		highlight_grey = "Comment",
	},
})

-- local Rule = require('nvim-autopairs.rule')
-- npairs.add_rule(Rule("(", ")"))

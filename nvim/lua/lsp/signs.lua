local signs = {
	{ name = "DiagnosticSignError", text = "", texthtl = "DiagnosticError" },
	{ name = "DiagnosticSignWarn", text = "", texthl = "DiagnosticWarn" },
	{ name = "DiagnosticSignHint", text = "", texthl = "DiagnosticHint" },
	{ name = "DiagnosticSignInfo", text = "", texthl = "DiagnosticInfo" },
}
-- trouble
-- error = "",
-- warning = "",
-- hint = "",
-- information = "",
-- other = "﫠",

for _, sign in ipairs(signs) do
	vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "", texthtl = sign.texthl })
end
vim.lsp.protocol.CompletionItemKind = {
	" [text]",
	" [method]",
	"ƒ [function]",
	" [constructor]",
	" [field]",
	" [variable]",
	" [class]",
	" [interface]",
	" [module]",
	" [property]",
	" [unit]",
	" [value]",
	" [enum]",
	" [keyword]",
	"﬌ [snippet]",
	" [color]",
	" [file]",
	" [reference]",
	" [dir]",
	" [enummember]",
	" [constant]",
	" [struct]",
	"  [event]",
	" [operator]",
	" [type]",
}

-- setup nvim-base16 with colors from flavours app
require("plugin.base16")
-- base16-colorscheme already required here
local base16 = require("base16-colorscheme")
local colors = base16.colors
local hi = base16.highlight

local hex_re = vim.regex("#\\x\\x\\x\\x\\x\\x")
local HEX_DIGITS = {
	["0"] = 0,
	["1"] = 1,
	["2"] = 2,
	["3"] = 3,
	["4"] = 4,
	["5"] = 5,
	["6"] = 6,
	["7"] = 7,
	["8"] = 8,
	["9"] = 9,
	["a"] = 10,
	["b"] = 11,
	["c"] = 12,
	["d"] = 13,
	["e"] = 14,
	["f"] = 15,
	["A"] = 10,
	["B"] = 11,
	["C"] = 12,
	["D"] = 13,
	["E"] = 14,
	["F"] = 15,
}

local function hex_to_rgb(hex)
	return HEX_DIGITS[string.sub(hex, 1, 1)] * 16 + HEX_DIGITS[string.sub(hex, 2, 2)],
		HEX_DIGITS[string.sub(hex, 3, 3)] * 16 + HEX_DIGITS[string.sub(hex, 4, 4)],
		HEX_DIGITS[string.sub(hex, 5, 5)] * 16 + HEX_DIGITS[string.sub(hex, 6, 6)]
end

local function rgb_to_hex(r, g, b)
	return bit.tohex(bit.bor(bit.lshift(r, 16), bit.lshift(g, 8), b), 6)
end

local function darken(hex, pct)
	pct = 1 - pct
	local r, g, b = hex_to_rgb(string.sub(hex, 2))
	r = math.floor(r * pct)
	g = math.floor(g * pct)
	b = math.floor(b * pct)
	return string.format("#%s", rgb_to_hex(r, g, b))
end

local darkerbg = darken(colors.base00, 0.1)
local darkercursorline = darken(colors.base01, 0.1)
local darkerstatusline = darken(colors.base02, 0.1)
hi.TelescopeResultsTitle = { guifg = darkercursorline, guibg = colors.base0B, gui = nil, guisp = nil }

-- optionally modify TS highlights
-- from start/nvim-base16/lua/base16-colorscheme.lua
-- hi.TSAnnotation         = { guifg = M.colors.base0F, guibg = nil, gui = 'none',          guisp = nil }
-- hi.TSAttribute          = { guifg = M.colors.base0A, guibg = nil, gui = 'none',          guisp = nil }
-- hi.TSBoolean            = { guifg = M.colors.base09, guibg = nil, gui = 'none',          guisp = nil }
-- hi.TSCharacter          = { guifg = M.colors.base08, guibg = nil, gui = 'none',          guisp = nil }
-- hi.TSComment            = { guifg = M.colors.base03, guibg = nil, gui = 'italic',        guisp = nil }
-- hi.TSConstructor        = { guifg = M.colors.base0D, guibg = nil, gui = 'none',          guisp = nil }
-- hi.TSConditional        = { guifg = M.colors.base0E, guibg = nil, gui = 'none',          guisp = nil }
-- hi.TSConstant           = { guifg = M.colors.base09, guibg = nil, gui = 'none',          guisp = nil }
-- hi.TSConstBuiltin       = { guifg = M.colors.base09, guibg = nil, gui = 'italic',        guisp = nil }
-- hi.TSConstMacro         = { guifg = M.colors.base08, guibg = nil, gui = 'none',          guisp = nil }
-- hi.TSError              = { guifg = M.colors.base08, guibg = nil, gui = 'none',          guisp = nil }
-- hi.TSException          = { guifg = M.colors.base08, guibg = nil, gui = 'none',          guisp = nil }
-- hi.TSField              = { guifg = M.colors.base05, guibg = nil, gui = 'none',          guisp = nil }
-- hi.TSFloat              = { guifg = M.colors.base09, guibg = nil, gui = 'none',          guisp = nil }
-- hi.TSFunction           = { guifg = M.colors.base0D, guibg = nil, gui = 'none',          guisp = nil }
-- hi.TSFuncBuiltin        = { guifg = M.colors.base0D, guibg = nil, gui = 'italic',        guisp = nil }
-- hi.TSFuncMacro          = { guifg = M.colors.base08, guibg = nil, gui = 'none',          guisp = nil }
-- hi.TSInclude            = { guifg = M.colors.base0D, guibg = nil, gui = 'none',          guisp = nil }
-- hi.TSKeyword            = { guifg = M.colors.base0E, guibg = nil, gui = 'none',          guisp = nil }
-- hi.TSKeywordFunction    = { guifg = M.colors.base0E, guibg = nil, gui = 'none',          guisp = nil }
-- hi.TSKeywordOperator    = { guifg = M.colors.base0E, guibg = nil, gui = 'none',          guisp = nil }
-- hi.TSLabel              = { guifg = M.colors.base0A, guibg = nil, gui = 'none',          guisp = nil }
-- hi.TSMethod             = { guifg = M.colors.base0D, guibg = nil, gui = 'none',          guisp = nil }
-- hi.TSNamespace          = { guifg = M.colors.base08, guibg = nil, gui = 'none',          guisp = nil }
-- hi.TSNone               = { guifg = M.colors.base05, guibg = nil, gui = 'none',          guisp = nil }
-- hi.TSNumber             = { guifg = M.colors.base09, guibg = nil, gui = 'none',          guisp = nil }
-- hi.TSOperator           = { guifg = M.colors.base05, guibg = nil, gui = 'none',          guisp = nil }
-- hi.TSParameter          = { guifg = M.colors.base05, guibg = nil, gui = 'none',          guisp = nil }
-- hi.TSParameterReference = { guifg = M.colors.base05, guibg = nil, gui = 'none',          guisp = nil }
-- hi.TSProperty           = { guifg = M.colors.base05, guibg = nil, gui = 'none',          guisp = nil }
-- hi.TSPunctDelimiter     = { guifg = M.colors.base0F, guibg = nil, gui = 'none',          guisp = nil }
-- hi.TSPunctBracket       = { guifg = M.colors.base05, guibg = nil, gui = 'none',          guisp = nil }
-- hi.TSPunctSpecial       = { guifg = M.colors.base05, guibg = nil, gui = 'none',          guisp = nil }
-- hi.TSRepeat             = { guifg = M.colors.base0E, guibg = nil, gui = 'none',          guisp = nil }
-- hi.TSString             = { guifg = M.colors.base0B, guibg = nil, gui = 'none',          guisp = nil }
-- hi.TSStringRegex        = { guifg = M.colors.base0C, guibg = nil, gui = 'none',          guisp = nil }
-- hi.TSStringEscape       = { guifg = M.colors.base0C, guibg = nil, gui = 'none',          guisp = nil }
-- hi.TSSymbol             = { guifg = M.colors.base0B, guibg = nil, gui = 'none',          guisp = nil }
-- hi.TSTag                = { guifg = M.colors.base0A, guibg = nil, gui = 'none',          guisp = nil }
-- hi.TSTagDelimiter       = { guifg = M.colors.base0F, guibg = nil, gui = 'none',          guisp = nil }
-- hi.TSText               = { guifg = M.colors.base05, guibg = nil, gui = 'none',          guisp = nil }
-- hi.TSStrong             = { guifg = nil,             guibg = nil, gui = 'bold',          guisp = nil }
-- hi.TSEmphasis           = { guifg = M.colors.base09, guibg = nil, gui = 'italic',        guisp = nil }
-- hi.TSUnderline          = { guifg = M.colors.base00, guibg = nil, gui = 'underline',     guisp = nil }
-- hi.TSStrike             = { guifg = M.colors.base00, guibg = nil, gui = 'strikethrough', guisp = nil }
-- hi.TSTitle              = { guifg = M.colors.base0D, guibg = nil, gui = 'none',          guisp = nil }
-- hi.TSLiteral            = { guifg = M.colors.base09, guibg = nil, gui = 'none',          guisp = nil }
-- hi.TSURI                = { guifg = M.colors.base09, guibg = nil, gui = 'underline',     guisp = nil }
-- hi.TSType               = { guifg = M.colors.base0A, guibg = nil, gui = 'none',          guisp = nil }
-- hi.TSTypeBuiltin        = { guifg = M.colors.base0A, guibg = nil, gui = 'italic',        guisp = nil }
-- hi.TSVariable           = { guifg = M.colors.base08, guibg = nil, gui = 'none',          guisp = nil }
-- hi.TSVariableBuiltin    = { guifg = M.colors.base08, guibg = nil, gui = 'italic',        guisp = nil }

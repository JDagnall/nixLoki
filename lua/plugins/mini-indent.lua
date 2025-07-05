-- Indent lines
return {
	"echasnovski/mini.indentscope",
	enabled = require("nixCatsUtils").enableForCategory("mini-indentscope", true),
	version = false,
	opts = {
		symbol = "▏",
		options = {
			try_as_border = true,
		},
	},
}

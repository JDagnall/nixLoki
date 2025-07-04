local ncUtil = require("nixCatsUtils")
-- nixCats utilites return default values if not on a nix system
-- enableForCategory: checks a category specification in the nixCats nix config
-- or returns the specified default value if not on a nix system
-- Indent lines
return {
	"echasnovski/mini.indentscope",
	enabled = ncUtil.enableForCategory("mini-indentscope", true),
	version = false,
	opts = {
		symbol = "▏",
		options = {
			try_as_border = true,
		},
	},
}

local ncUtil = require("nixCatsUtils")
local nixCats = require("nixCats")
-- nixCats utilites return default values if not on a nix system
-- enableForCategory: checks a category specification in the nixCats nix config
-- or returns the specified default value if not on a nix system

return {
	"nvim-mini/mini.base16",
	-- version = false,
	enabled = ncUtil.enableForCategory("mini-base16", false),
	config = {
		pallete = nixCats.extra("base16Colours") or {},
		plugins = { default = false },
	},
}

-- required for lazy.nvim (kind of) and image.nvim
return {
	"vhyrro/luarocks.nvim",
	enabled = require("nixCatsUtils").enableForCategory("luarocks", true),
	priority = 1001, -- this plugin needs to run before anything else
	opts = {
		rocks = { "magick" },
	},
	config = true,
}

return {
	"RRethy/vim-illuminate",
	config = function()
		require("illuminate").configure({
			modes_allowlist = { "n" },
			providers = { "lsp" },
		})
	end,
	enabled = require("nixCatsUtils").enableForCategory("vim-illuminate", true),
}

return {
	"tpope/vim-fugitive",
	enabled = require("nixCatsUtils").enableForCategory("vim-fugitive", true),
	keys = {
		{ mode = "n", "<leader>gs", "<cmd> vertical Git<CR>" },
	},
}

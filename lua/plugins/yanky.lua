return {
	"gbprod/yanky.nvim",
	enabled = require("nixCatsUtils").enableForCategory("yanky", false),
	lazy = true,
	dependencies = { "nvim-telescope/telescope.nvim" },
	opts = {
		telescope = {
			use_default_mappings = true,
		},
		system_clipboard = {
			sync_with_ring = false,
		},
	},
	config = function(_, opts)
		require("yanky").setup(opts)
		require("telescope").load_extension("yank_history")
	end,
	keys = {
		{ mode = "n", "<C-y>", ":Telescope yank_history<CR>", desc = "Picker for yank history" },
	},
}

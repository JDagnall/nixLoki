return {
	"gbprod/yanky.nvim",
	enabled = require("nixCatsUtils").enableForCategory("yanky", true),
	lazy = true,
	dependencies = { "nvim-telescope/telescope.nvim", "folke/snacks.nvim" },
	opts = {
		picker = {
			select = {
				action = nil,
			},
			telescope = {
				use_default_mappings = true,
				mapping = nil,
			},
		},
		system_clipboard = {
			sync_with_ring = false,
		},
	},
	config = function(_, opts)
		require("yanky").setup(opts)
		if vim.g.telescope_enabled then
			require("telescope").load_extension("yank_history")
			vim.keymap.set("n", "<C-y>", ":Telescope yank_history")
		elseif vim.g.snacks_picker_enabled then
			vim.keymap.set("n", "<C-y>", function()
				require("snacks").picker.yanky()
			end)
		end
	end,
	keys = {},
}

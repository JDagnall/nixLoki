local ncUtil = require("nixCatsUtils")
return {
	-- Allows displaying git blames among other things
	"lewis6991/gitsigns.nvim",
	enabled = ncUtil.enableForCategory("gitsigns", true),
	opts = {
		signs_staged_enable = true,
		signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
		numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
		linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
		word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
	},
	keys = {
		{ mode = "n", "<leader>b", ":Gitsigns toggle_current_line_blame<CR>" },
		{ mode = "n", "<leader>B", ":Gitsigns blame<CR>" },
	},
}

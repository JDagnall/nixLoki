return {
	"mrjones2014/smart-splits.nvim",
	enabled = require("nixCatsUtils").enableForCategory("smart-splits", true),
	lazy = false,
	keys = function()
		local splits = require("smart-splits")
		-- moving between splits
		return {
			{ mode = "n", "<C-h>", splits.move_cursor_left, desc = "moves left in both multiplexer and nvim windows" },
			{ mode = "n", "<C-j>", splits.move_cursor_down, desc = "moves down in both multiplexer and nvim windows" },
			{ mode = "n", "<C-k>", splits.move_cursor_up, desc = "moves up in both multiplexer and nvim windows" },
			{
				mode = "n",
				"<C-l>",
				splits.move_cursor_right,
				desc = "moves right in both multiplexer and nvim windows",
			},
		}
	end,
}

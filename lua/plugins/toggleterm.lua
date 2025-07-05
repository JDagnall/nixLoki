return {
	"akinsho/toggleterm.nvim",
	enabled = require("nixCatsUtils").enableForCategory("toggleterm", true),
	lazy = true,
	init = function()
		vim.opt.hidden = true
	end,
	opts = {
		direction = "float", -- or tab or horizontal or vertical
		open_mapping = [[<c-\>]], -- or [[<c-`>]]
		start_in_insert = true,
		persist_size = true,
		persist_mode = true,
		close_one_exit = true,
		auto_scroll = true,
		-- size = num.
		-- shell = ,
		float_ops = {
			border = "rounded", -- or single, shadow, double
			-- width = ,
			-- height = ,
			-- row = ,
			-- col = ,
			-- winblend = ,
			-- zindex = ,
			title_pos = "left",
		},
	},
	keys = {
		[[<c-\>]],
		[[<c-`>]],
	},
}

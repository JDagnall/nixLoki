return {
	"folke/trouble.nvim",
	enabled = require("nixCatsUtils").enableForCategory("trouble", true),
	opts = {
		multiline = true,
		restore = true,
		follow = true,
		action_keys = {
			hover = "K",
		},
		win = {
			size = 0.35,
			wo = {
				-- wrap = true,
			},
		},
	},
	dependencies = { "nvim-tree/nvim-web-devicons" },
	cmd = "Trouble",
	keys = {
		{
			"<leader>Q",
			"<cmd>Trouble diagnostics toggle focus=false win.position=right size=0.4<cr>",
			desc = "Diagnostics (Trouble)",
		},
		{
			"<leader>ls",
			"<cmd>Trouble symbols toggle focus=false win.position=right<cr>",
			desc = "Symbols (Trouble)",
		},
		{
			"<leader>cl",
			"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
			desc = "LSP Definitions / references / ... (Trouble)",
		},
		{
			"<leader>ll",
			"<cmd>Trouble loclist toggle focus=false win.position=right<cr>",
			desc = "Location List (Trouble)",
		},
		{
			"<leader>xQ",
			"<cmd>Trouble qflist toggle focus=false win.position=right<cr>",
			desc = "Quickfix List (Trouble)",
		},
	},
}

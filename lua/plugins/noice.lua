return {
	"folke/noice.nvim",
	enabled = require("nixCatsUtils").enableForCategory("noice", false),
	dependencies = {
		-- "MunifTanjim/nui.nvim",
		{ "pynappo/nui.nvim", branch = "support-winborder" },
		"rcarriga/nvim-notify",
	},
	event = "VeryLazy",
	opts = {
		cmdline = {
			enabled = true,
			view = "cmdline", -- or cmdline_popup
		},
		messages = {
			enabled = true,
			view = "mini",
			view_error = "mini",
			view_warn = "mini",
			view_history = "mini",
			view_search = "mini",
		},
		notify = {
			enabled = true,
			view = "mini",
		},
		views = {
			mini = {
				align = "message-right",
				-- size = {
				-- 	width = "35%",
				-- 	hight = "auto",
				-- },
			},
		},
		popupmenu = {
			enabled = true,
			backend = "cmp",
		},
		redirect = {},
		lsp = {
			progress = {
				enabled = false,
				view = "mini",
			},
			override = {
				-- overrides make cmp windows use treesitter
				["vim.lsp.util.convert_input_to_markdown_lines"] = true,
				["vim.lsp.util.stylize_markdown"] = true,
				["cmp.entry.get_documentation"] = true,
			},
			hover = { enabled = false, silent = true },
			signature = { enabled = false },
			messages = { enabled = true, view = "mini" },
		},
		presets = {
			long_message_to_split = true, -- long messages will be sent to a split
		},
	},
	init = function()
		require("telescope").load_extension("noice")
		vim.keymap.set("n", "<leader>h", ":Telescope noice<CR>", { desc = "Noice history" })
	end,
}

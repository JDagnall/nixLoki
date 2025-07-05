-- Runner supposed to be for jupyter notebooks
return {
	"benlubas/molten-nvim",
	enabled = require("nixCatsUtils").enableForCategory("molten", false),
	version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
	dependencies = { "willothy/wezterm.nvim", "3rd/image.nvim" },
	build = ":UpdateRemotePlugins",
	init = function()
		-- wezterm image provider settings
		vim.g.molten_auto_open_ouput = false -- incompatible
		vim.g.molten_image_provider = "wezterm"
		vim.g.molten_split_direction = "right"
		vim.g.molten_split_size = 40 -- %
		--

		vim.g.molten_output_win_max_height = 20
		vim.g.molten_wrap_output = true
		vim.g.molten_virt_text_output = true
		vim.g.molten_virt_lines_off_by_1 = true
	end,
	keys = {
		{
			mode = "n",
			"<leader>mi",
			":MoltenInit<CR>",
			silent = true,
			desc = "Initialize the plugin",
		},
		{
			mode = "n",
			"<leader>e",
			":MoltenEvaluateOperator<CR>",
			silent = true,
			desc = "run operator selection",
		},
		{
			mode = "n",
			"<leader>rl",
			":MoltenEvaluateLine<CR>",
			silent = true,
			desc = "evaluate line",
		},
		{
			mode = "n",
			"<leader>rr",
			":MoltenReevaluateCell<CR>",
			silent = true,
			desc = "re-evaluate cell",
		},
		{
			mode = "v",
			"<leader>r",
			":<C-u>MoltenEvaluateVisual<CR>gv",
			silent = true,
			desc = "evaluate visual selection",
		},

		{
			mode = "n",
			"<leader>md",
			":MoltenDelete<CR>",
			silent = true,
			desc = "molten delete cell",
		},
		{
			mode = "n",
			"<leader>mh",
			":MoltenHideOutput<CR>",
			silent = true,
			desc = "hide output",
		},
		{
			mode = "n",
			"<leader>ms",
			":noautocmd MoltenEnterOutput<CR>",
			silent = true,
			desc = "show/enter output",
		},
	},
}

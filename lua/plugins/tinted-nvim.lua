local ncUtil = require("nixCatsUtils")
local nixCats = require("nixCats")
-- nixCats utilites return default values if not on a nix system
-- enableForCategory: checks a category specification in the nixCats nix config
-- or returns the specified default value if not on a nix system

return {
	"tinted-theming/tinted-nvim",
	-- version = false,
	enabled = ncUtil.enableForCategory("tinted-nvim", false),
	priority = 1000,
	opts = {
		supports = { tinty = false, tinted_shell = false, live_reload = false },
		highlights = {
			telescope = true,
			telescope_borders = true,
			indentblankline = false,
			notify = false,
			ts_rainbow = true,
			cmp = true,
			illuminate = true,
			lsp_semantic = true,
			mini_completion = false,
			dapui = false,
		},
	},
	config = function(_, opts)
		local colours = nixCats.extra("base16Colours") or "base16-catppuccin-mocha"
		require("tinted-colorscheme").setup(colours, opts)

		-- redefine incase we fell back to catppuccin
		colours = require("tinted-colorscheme").colors

		-- variables, I hate them being red
		vim.api.nvim_set_hl(0, "TSVariable", { fg = colours.base07, bg = nil })
		vim.api.nvim_set_hl(0, "TSVariableBuiltin", { fg = colours.base07, bg = nil })
		vim.api.nvim_set_hl(0, "Identifier", { fg = colours.base07, bg = nil })
		-- command line
		vim.api.nvim_set_hl(0, "MoreMsg", { fg = nil, bg = colours.base01 })
		vim.api.nvim_set_hl(0, "MsgArea", { fg = nil, bg = colours.base01 })
		vim.api.nvim_set_hl(0, "ModeMsg", { fg = nil, bg = colours.base01 })
		vim.api.nvim_set_hl(0, "MsgSeparator", { fg = nil, bg = colours.base01 })
		-- nvim-cmp completion highlights
		vim.api.nvim_set_hl(0, "CmpNormal", { fg = nil, bg = colours.base01 })
		vim.api.nvim_set_hl(0, "CmpSel", { fg = nil, bg = colours.base02 })
		vim.api.nvim_set_hl(0, "CmpItemAbbr", { fg = nil, bg = nil })
		vim.api.nvim_set_hl(0, "CmpDocumentation", { fg = nil, bg = colours.base01 })
		vim.api.nvim_set_hl(0, "SearchBar", { fg = nil, bg = colours.base02 })
		-- trouble
		-- vim.api.nvim_set_hl(0, "TroubleNormal", { fg = nil, bg = "none" })
		-- vim.api.nvim_set_hl(0, "TroubleNormalNC", { fg = nil, bg = "none" })
	end,
}

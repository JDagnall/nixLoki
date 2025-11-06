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
		local colours = nixCats.extra("base16Colours") or {}
		require("tinted-theming").setup(colours, opts)

		-- -- command line
		-- vim.api.nvim_set_hl(0, "MsgArea", { fg = nil, bg = colours.base00 })
		-- vim.api.nvim_set_hl(0, "MoreMsg", { fg = nil, bg = colours.base00 })
		-- vim.api.nvim_set_hl(0, "ModeMsg", { fg = nil, bg = colours.base00 })
		-- vim.api.nvim_set_hl(0, "MsgSeparator", { fg = nil, bg = colours.base00 })
		-- -- nvim-cmp completion highlights
		-- vim.api.nvim_set_hl(0, "CmpNormal", { fg = nil, bg = colours.base01 })
		-- vim.api.nvim_set_hl(0, "CmpSel", { fg = nil, bg = colours.base02 })
		-- vim.api.nvim_set_hl(0, "DocNormal", { fg = nil, bg = colours.base01 })
		-- vim.api.nvim_set_hl(0, "SearchBar", { fg = nil, bg = colours.base02 })
		-- -- Line numbers
		-- vim.api.nvim_set_hl(0, "LineNr", { fg = colours.base04, bg = "none" })
		-- vim.api.nvim_set_hl(0, "LineNrAbove", { fg = colours.base04, bg = "none" })
		-- vim.api.nvim_set_hl(0, "LineNrBelow", { fg = colours.base04, bg = "none" })
		-- -- trouble
		-- vim.api.nvim_set_hl(0, "TroubleNormal", { fg = nil, bg = "none" })
		-- vim.api.nvim_set_hl(0, "TroubleNormalNC", { fg = nil, bg = "none" })
		-- -- lualine, cant really work with mini-base16
		-- -- gitsigns
		-- vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = colours.base0B, bg = "none" })
		-- vim.api.nvim_set_hl(0, "GitSignsChange", { fg = colours.base0E, bg = "none" })
		-- vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = colours.base08, bg = "none" })
		-- vim.api.nvim_set_hl(0, "GitSignsUntracked", { fg = colours.base0D, bg = "none" })
	end,
}

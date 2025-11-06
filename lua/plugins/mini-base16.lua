local ncUtil = require("nixCatsUtils")
local nixCats = require("nixCats")
-- nixCats utilites return default values if not on a nix system
-- enableForCategory: checks a category specification in the nixCats nix config
-- or returns the specified default value if not on a nix system

-- fallback for base16 palette
local mocha = {
	["base00"] = "#1e1e2e", -- base
	["base01"] = "#181825", -- mantle
	["base02"] = "#313244", -- surface0
	["base03"] = "#45475a", -- surface1
	["base04"] = "#585b70", -- surface2
	["base05"] = "#cdd6f4", -- text
	["base06"] = "#f5e0dc", -- rosewater
	["base07"] = "#b4befe", -- lavender
	["base08"] = "#f38ba8", -- red
	["base09"] = "#fab387", -- peach
	["base0A"] = "#f9e2af", -- yellow
	["base0B"] = "#a6e3a1", -- green
	["base0C"] = "#94e2d5", -- teal
	["base0D"] = "#89b4fa", -- blue
	["base0E"] = "#cba6f7", -- mauve
	["base0F"] = "#f2cdcd", -- flamingo
}

return {
	"nvim-mini/mini.base16",
	-- version = false,
	enabled = ncUtil.enableForCategory("mini-base16", false),
	priority = 1000,
	opts = {
		palette = nixCats.extra("base16Colours"),
		use_cterm = false,
		plugins = { default = true },
	},
	config = function(_, opts)
		require("mini.base16").setup(opts)

		local colours = nixCats.extra("base16Colours")

		-- command line
		vim.api.nvim_set_hl(0, "MsgArea", { fg = nil, bg = colours.base00 })
		vim.api.nvim_set_hl(0, "MoreMsg", { fg = nil, bg = colours.base00 })
		vim.api.nvim_set_hl(0, "ModeMsg", { fg = nil, bg = colours.base00 })
		vim.api.nvim_set_hl(0, "MsgSeparator", { fg = nil, bg = colours.base00 })
		-- nvim-cmp completion highlights
		vim.api.nvim_set_hl(0, "CmpNormal", { fg = nil, bg = colours.base01 })
		vim.api.nvim_set_hl(0, "CmpSel", { fg = nil, bg = colours.base02 })
		vim.api.nvim_set_hl(0, "DocNormal", { fg = nil, bg = colours.base01 })
		vim.api.nvim_set_hl(0, "SearchBar", { fg = nil, bg = colours.base02 })
		-- Line numbers
		vim.api.nvim_set_hl(0, "LineNr", { fg = colours.base04, bg = "none" })
		vim.api.nvim_set_hl(0, "LineNrAbove", { fg = colours.base04, bg = "none" })
		vim.api.nvim_set_hl(0, "LineNrBelow", { fg = colours.base04, bg = "none" })
		-- trouble
		vim.api.nvim_set_hl(0, "TroubleNormal", { fg = nil, bg = "none" })
		vim.api.nvim_set_hl(0, "TroubleNormalNC", { fg = nil, bg = "none" })
		-- lualine, cant really work with mini-base16
		-- gitsigns
		vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = colours.base0B, bg = "none" })
		vim.api.nvim_set_hl(0, "GitSignsChange", { fg = colours.base0E, bg = "none" })
		vim.api.nvim_set_hl(0, "GitSignsDelete", { fg = colours.base08, bg = "none" })
		vim.api.nvim_set_hl(0, "GitSignsUntracked", { fg = colours.base0D, bg = "none" })
	end,
}

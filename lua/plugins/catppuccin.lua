-- theme
return {
	"catppuccin/nvim",
	name = "catppuccin",
	enabled = require("nixCatsUtils").enableForCategory("catppuccin", true),
	priority = 1000,
	opts = {
		flavour = "mocha",
		transparent_background = false,
		default_integrations = true,
		custom_highlights = function(colors)
			return {
				-- The message area underneath the cmd line
				MsgArea = { bg = colors.mantle, fg = colors.text },
				MoreMsg = { bg = colors.mantle, fg = colors.text },
				-- ModeMsg = { bg = colors.mantle, fg = colors.teal },
				MsgSeparator = { bg = colors.mantle, fg = colors.text },
				-- nvim-cmp completion highlights
				CmpNormal = { bg = colors.mantle },
				CmpSel = { bg = colors.surface0 },
				DocNormal = { bg = colors.mantle },
				SearchBar = { bg = colors.overlay1 },
				-- dashboard.nvim highlights
				DashBoardHeader = { bg = "none", fg = colors.maroon },
				DashBoardFooter = { bg = "none", fg = colors.overlay1 },
				-- doom
				DashboardIcon = { bg = "none", fg = colors.mauve },
				DashboardDesc = { bg = "none", fg = colors.teal },
				DashboardKey = { bg = "none", fg = colors.peach },
				DashboardShortCut = { bg = "none", fg = colors.pink },
				-- snacks.nvim dashboard highlights
				SnacksDashboardHeader = { bg = "none", fg = colors.mauve },
				SnacksDashboardFooter = { bg = "none", fg = colors.overlay1 },
				SnacksDashboardIcon = { bg = "none", fg = colors.mauve },
				SnacksDashboardDesc = { bg = "none", fg = colors.teal },
				SnacksDashboardKey = { bg = "none", fg = colors.peach },
				SnacksDashboardSpecial = { bg = "none", fg = colors.pink },
				SnacksDashboardDir = { bg = "none", fg = colors.overlay1 },
				SnacksDashboardFile = { bg = "none", fg = colors.teal },
				-- trouble
				TroubleNormal = { bg = "none", fg = colors.text },
				TroubleNormalNC = { bg = "none", fg = colors.text },
			}
		end,
		integrations = {
			cmp = true,
			treesitter = true,
			mini = {
				enabled = true,
				indentscope_color = "",
			},
			mason = true,
			native_lsp = {
				enabled = true,
				virtual_text = {
					errors = { "italic" },
					hints = { "italic" },
					warnings = { "italic" },
					information = { "italic" },
					ok = { "italic" },
				},
				underlines = {
					errors = { "underline" },
					hints = { "underline" },
					warnings = { "underline" },
					information = { "underline" },
					ok = { "underline" },
				},
				inlay_hints = {
					background = true,
				},
			},
			telescope = {
				enabled = true,
			},
			nvim_surround = true,
			lsp_trouble = true,
			dashboard = true,
			gitsigns = true,
			noice = true,
			harpoon = true,
		},
	},
	config = function(_, opts)
		require("catppuccin").setup(opts)
		vim.cmd([[colorscheme catppuccin]])
	end,
}

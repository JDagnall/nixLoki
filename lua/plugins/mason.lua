return {
	"williamboman/mason.nvim",
	enabled = require("nixCatsUtils").enableForCategory("mason", true),
	dependencies = {
		-- "williamboman/mason-lspconfig.nvim",
		"neovim/nvim-lspconfig",
	},
	version = "*",
	cmd = "Mason",
	build = ":MasonUpdate",
	opts_extend = { "ensure_installed" },
	opts = {
		automatic_installation = true,
		ensure_installed = {
			-- formatters
			"ruff",
			"autopep8",
			"stylua",
			"nixfmt",
			"clang-format",
			"shfmt",
			"djlint",
			"prettier",
		},
	},
}

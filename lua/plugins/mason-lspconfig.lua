return {
	"williamboman/mason-lspconfig.nvim",
	enabled = require("nixCatsUtils").enableForCategory("mason-lspconfig", true),
	dependencies = {
		"williamboman/mason.nvim",
		"neovim/nvim-lspconfig",
	},
	version = "*",
	opts = {
		automatic_enable = {
			exclude = {
				"ruff", -- I only want ruff as a formatter
			},
		},
		ensure_installed = {
			-- LSPS
			"lua_ls",
			"pylsp",
			"gopls",
			"clangd",
			"tsserver",
		},
	},
	config = function(_, opts)
		require("mason-lspconfig").setup(opts)
		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim", "require" },
					},
				},
			},
		})
	end,
}

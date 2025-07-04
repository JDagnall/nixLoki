local ncUtil = require("nixCatsUtils")
-- nixCats utilites return default values if not on a nix system
-- enableForCategory: checks a category specification in the nixCats nix config
-- or returns the specified default value if not on a nix system

local formatters = {
	"nixfmt",
	"stylua",
	"gofmt",
	"clang-format",
	"ruff", -- i only want ruff as a formatter
	"autopep8",
	"shfmt",
	"djlint",
}

-- nix cats categories corresponding to formatters
local formatter_cats = {
	["nixfmt"] = "lang.nix",
	["stylua"] = "lang.lua",
	["gofmt"] = "lang.go",
	["clang-format"] = "lang.c",
	["ruff"] = "lang.python",
	["autopep8"] = "lang.python",
	["shfmt"] = "lang.bash",
	["djlint"] = "lang.jinja",
}

return {
	"stevearc/conform.nvim",
	enabled = ncUtil.enableForCategory("conform", true),
	opts = {
		-- TODO: make it so that nixCats is checked before formatters are included
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "autopep8", "ruff_format", "ruff_fix" },
			nix = { "nixfmt" },
			go = { "gofmt" },
			c = { "clang-format" },
			htmldjango = { "djlint" },
			html = { "djlint" },
			jango = { "djlint" },
			bash = { "shfmt" },
			sh = { "shfmt" },
			shell = { "shfmt" },
		},
		-- individual formatter options
		formatters = {
			nixfmt = {
				append_args = {
					"--indent=4",
				},
			},
		},
		format_on_save = function(bufnr)
			-- Disable with a global or buffer-local variable
			if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
				return
			end
			return { timeout_ms = 500, lsp_format = "fallback" }
		end,
	},

	cmd = { "ConformInfo" },
	keys = {
		{
			-- Customize or remove this keymap to your liking
			"<leader>f",
			function()
				require("conform").format({ async = true })
			end,
			mode = { "n", "v" },
			desc = "Format buffer",
		},
		{
			-- Customize or remove this keymap to your liking
			"<leader>ff",
			function()
				require("conform").format({ async = true })
			end,
			mode = { "n", "v" },
			desc = "Format buffer",
		},
	},
	init = function()
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
		vim.api.nvim_create_autocmd("BufWritePre", {
			pattern = "*",
			callback = function(args)
				require("conform").format({ bufnr = args.buf })
			end,
		})
	end,
}

local ncUtil = require("nixCatsUtils")
-- nixCats utilites return default values if not on a nix system
-- enableForCategory: checks a category specification in the nixCats nix config
-- or returns the specified default value if not on a nix system

local ft_by_formatter_and_cat = {
	python = {
		formatters = { "ruff_format", "ruff_fix", "autopep8" },
		enabled = ncUtil.enableForCategory("lang.python", true),
	},
	lua = { formatters = { "stylua" }, enabled = ncUtil.enableForCategory("lang.python", true) },
	nix = { formatters = { "nixfmt" }, enabled = ncUtil.enableForCategory("lang.nix", true) },
	go = { formatters = { "gofmt" }, enabled = ncUtil.enableForCategory("lang.go", true) },
	c = { formatters = { "clang-format" }, enabled = ncUtil.enableForCategory("lang.c", true) },
	bash = { formatters = { "shfmt" }, enabled = ncUtil.enableForCategory("lang.bash", true) },
	sh = { formatters = { "shfmt" }, enabled = ncUtil.enableForCategory("lang.bash", true) },
	shell = { formatters = { "shfmt" }, enabled = ncUtil.enableForCategory("lang.bash", true) },
	htmldjango = { formatters = { "djlint" }, enabled = ncUtil.enableForCategory("lang.jinja", true) },
	css = { formatters = { "prettier" }, enabled = ncUtil.enableForCategory("lang.css", true) },
	html = { formatters = { "prettier" }, enabled = ncUtil.enableForCategory("lang.html", true) },
	toml = { formatters = { "prettier" }, enabled = ncUtil.enableForCategory("lang.toml", true) },
	markdown = { formatters = { "prettier" }, enabled = ncUtil.enableForCategory("lang.markdown", true) },
	json = { formatters = { "prettier" }, enabled = ncUtil.enableForCategory("lang.json", true) },
	javascript = { formatters = { "prettier" }, enabled = ncUtil.enableForCategory("lang.javascript", true) },
}
local enabled_fts = {}

for k, v in pairs(ft_by_formatter_and_cat) do
	if v.enabled then
		enabled_fts[k] = v.formatters
	end
end

return {
	"stevearc/conform.nvim",
	enabled = ncUtil.enableForCategory("conform", true),
	opts = {
		formatters_by_ft = enabled_fts,
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

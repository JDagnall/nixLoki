local ncUtil = require("nixCatsUtils")
-- nixCats utilites return default values if not on a nix system
-- enableForCategory: checks a category specification in the nixCats nix config
-- or returns the specified default value if not on a nix system
-- lazyAdd: returns the first specified value if not on a nix system
-- and the second if currently configure by nixCats

-- syntax highlighting
return {
	"nvim-treesitter/nvim-treesitter",
	enabled = ncUtil.enableForCategory("treesitter", true),
	build = ncUtil.lazyAdd(":TSUpdate", nil),
	config = function(_, opts)
		---@param buf integer
		---@param language string
		local function treesitter_try_attach(buf, language)
			-- check if parser exists and load it
			if not vim.treesitter.language.add(language) then
				return false
			end
			-- enables syntax highlighting and other treesitter features
			vim.treesitter.start(buf, language)

			-- enables treesitter based folds
			vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
			vim.wo.foldmethod = "expr"
			-- ensure folds are open to begin with
			vim.o.foldlevel = 99

			-- enables treesitter based indentation
			vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

			return true
		end

		local installable_parsers = require("nvim-treesitter").get_available()
		vim.api.nvim_create_autocmd("FileType", {
			callback = function(args)
				local buf, filetype = args.buf, args.match
				local language = vim.treesitter.language.get_lang(filetype)
				if not language then
					return
				end

				if not treesitter_try_attach(buf, language) then
					if vim.tbl_contains(installable_parsers, language) then
						-- not already installed, so try to install them via nvim-treesitter if possible
						require("nvim-treesitter").install(language):await(function()
							treesitter_try_attach(buf, language)
						end)
					end
				end
			end,
		})

		require("nvim-treesitter").setup({
			-- only if on a non-nix system, nix handles grammar installs
			ensure_installed = ncUtil.lazyAdd({ "c", "python", "lua" }, {}),
			parser_install_dir = ncUtil.lazyAdd(vim.fn.stdpath("data") .. "/lazy/nvim-treesitter", nil),

			-- Install parsers synchronously (only applied to `ensure_installed`)
			sync_install = false,

			-- Automatically install missing parsers when entering buffer
			-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
			auto_install = not ncUtil.isNixCats,

			highlight = {
				enable = true,

				-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
				-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
				-- Using this option may slow down your editor, and you may see some duplicate highlights.
				-- Instead of true it can also be a list of languages
				additional_vim_regex_highlighting = false,
			},

			indent = {
				enable = true,
			},
		})
		require("nvim-treesitter.parsers").jinja2 = {
			install_info = {
				url = "https://github.com/JDaggers/tree-sitter-embedded-jinja.git",
				files = { "src/parser.c" },
				branch = "main",
				generate_requires_npm = false,
				requires_generate_from_grammar = false,
				queries = "queries",
			},
			-- filetype = "j2",
		}
		vim.treesitter.language.register("jinja2", "html.j2")
		vim.treesitter.language.register("jinja2", "j2")
		vim.filetype.add({
			extension = {
				["html.j2"] = "jinja2",
				j2 = "jinja2",
			},
		})
	end,
}

local ncUtil = require("nixCatsUtils")
-- nixCats utilites return default values if not on a nix system
-- enableForCategory: checks a category specification in the nixCats nix config
-- or returns the specified default value if not on a nix system

local lsps = {
	"nixd",
	"lua_ls",
	"gopls",
	"clangd",
	"ruff",
	"jedi_language_server",
	"tsserver",
	"jsonls",
}

-- nix cats categories corresponding to lsps
local lsp_cats = {
	["nixd"] = "lang.nix",
	["lua_ls"] = "lang.lua",
	["gopls"] = "lang.go",
	["clangd"] = "lang.c",
	["ruff"] = "lang.python",
	["jedi_language_server"] = "lang.python",
	-- ["pyright"] = "lang.python",
	-- ["pylsp"] = "lang.python",
	["tsserver"] = "lang.javascript",
	["jsonls"] = "lang.json",
}

local lsp_settings = {
	["lua_ls"] = {
		Lua = {
			diagnostics = {
				globals = { "vim", "require" },
			},
		},
	},
}

local function configure_lsp(lsp, capabilities)
	-- if the category is disable in nixCats
	if lsp_cats[lsp] ~= nil and not ncUtil.enableForCategory(lsp_cats[lsp], true) then
		return
	end
	vim.lsp.config(lsp, {
		capabilities = capabilities,
		settings = lsp_settings[lsp] or nil,
	})
	vim.lsp.enable(lsp)
end

-- Main lsp plugin
return {
	"neovim/nvim-lspconfig",
	enabled = ncUtil.enableForCategory("lspconfig", true),
	dependencies = {},
	lazy = false,
	keys = function()
		local options = { buffer = bufnr, remap = false }
		local rr_active = false
		return {
			{
				mode = "n",
				"gd",
				function()
					vim.lsp.buf.definition()
				end,
				options,
			},
			{
				mode = "n",
				"K",
				function()
					vim.lsp.buf.hover()
				end,
				options,
			},
			{
				mode = "n",
				"]d",
				function()
					vim.diagnostic.goto_next()
				end,
				options,
			},
			{
				mode = "n",
				"[d",
				function()
					vim.diagnostic.goto_prev()
				end,
				options,
			},
			{
				mode = "n",
				"<leader>ca",
				function()
					vim.lsp.buf.code_action()
				end,
				options,
			},
			{
				mode = "n",
				"<leader>rn",
				function()
					vim.lsp.buf.rename()
				end,
				options,
			},
			-- toggle reference list of hovered symbol
			{
				mode = "n",
				"<leader>rr",
				function()
					if rr_active then
						vim.api.nvim_command("cclose")
					else
						vim.lsp.buf.references()
					end
					rr_active = not rr_active
				end,
				options,
			},

			{
				mode = "n",
				"<C-s>",
				function()
					vim.lsp.buf.signature_help()
				end,
				options,
			},
		}
	end,
	opts = {
		-- options for vim.diagnostic.config()
		diagnostics = {
			underline = true,
			update_in_insert = false,
			virtual_text = {},
			severity_sort = true,
		},
		-- provide the inlay hints.
		inlay_hints = {
			enabled = true,
			exclude = {}, -- filetypes for which you don't want to enable inlay hints
		},
		-- add any global capabilities here
		capabilities = {
			workspace = {
				fileOperations = {
					didRename = true,
					willRename = true,
				},
			},
		},
		-- options for vim.lsp.buf.format
		format = {
			formatting_options = nil,
			timeout_ms = nil,
		},
		-- LSP Server Settings
		servers = {},
	},
	config = function(_, opts)
		vim.diagnostic.config(opts.diagnostics)
		-- run configure_lsp for every lsp in list
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		if ncUtil.enableForCategory("cmp", true) then
			capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)
		end
		for _, lsp in pairs(lsps) do
			configure_lsp(lsp, capabilities)
		end
	end,
}

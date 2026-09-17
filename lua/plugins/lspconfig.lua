local ncUtil = require("nixCatsUtils")
-- nixCats utilites return default values if not on a nix system
-- enableForCategory: checks a category specification in the nixCats nix config
-- or returns the specified default value if not on a nix system

-- nix cats categories corresponding to lsps
local lsp_cats = {
	["nixd"] = "lang.nix",
	["lua_ls"] = "lang.lua",
	["gopls"] = "lang.go",
	["clangd"] = "lang.c",
	["ruff"] = "lang.python",
	-- one day i will like a python lsp
	-- ["jedi_language_server"] = "lang.python",
	-- ["pyright"] = "lang.python",
	-- ["pylsp"] = "lang.python",
	["basedpyright"] = "lang.python",
	["ts_ls"] = "lang.javascript",
	["jsonls"] = "lang.json",
	["rust_analyzer"] = "lang.rust",
	["zls"] = "lang.zig",
	["harper_ls"] = "lang.english",
	["cssls"] = "lang.css",
	["html"] = "lang.html", -- yes its actually just called 'html' in lspconfig
	["sqls"] = "lang.sql",
	["sqruff"] = "lang.sql",
}

local lsp_settings = {
	["lua_ls"] = {
		settings = {
			Lua = {
				runtime = {
					-- Tell the language server which version of Lua you're using
					version = "LuaJIT",
				},
				workspace = {
					-- Make the server aware of Neovim runtime files
					library = vim.api.nvim_get_runtime_file("lua", true),
				},
				-- Do not send telemetry data containing a randomized but unique identifier
				telemetry = {
					enable = false,
				},
				diagnostics = {
					globals = { "vim", "require", "bufnr" },
				},
			},
		},
	},
	["harper_ls"] = {
		filetypes = { "markdown" },
		settings = {
			["harper-ls"] = {
				dialect = "Australian",
			},
		},
	},
	["clangd"] = function()
		-- this is mostly for specifying a query driver among other things
		-- specific to an environment
		local extra_flags = os.getenv("CLANGD_EXTRA_FLAGS")
		local clangd_cmd = {
			"clangd",
		}
		if extra_flags then
			for flag in string.gmatch(extra_flags, "%S+") do
				table.insert(clangd_cmd, flag)
			end
		end
		return {
			cmd = clangd_cmd,
		}
	end,
	["sqruff"] = {
		root_markers = { ".sqruff", ".sqruff.toml", ".sqruff.ini", "pyproject.toml" },
	},
}

local lsp_log_size_ideal = 10 * 1024 * 1024 -- mb
local lsp_log_size_thresh = 20 * 1024 * 1024 -- mb

local function get_lsp_log_size()
	local logfile = io.open(vim.lsp.log.get_filename())
	if logfile == nil then
		return
	end
	local filesize = logfile:seek("end")
	logfile:close()
	return filesize
end

local function shrink_lsp_log(size)
	local logfile = io.open(vim.lsp.log.get_filename(), "r")
	if logfile == nil then
		return
	end
	local filesize = logfile:seek("end")
	if filesize <= size then
		logfile:close()
		return
	end
	logfile:seek("set", filesize - size)
	local partial_line = logfile:read("*l") -- reads out till the next newline
	local remaining_lines = logfile:read("*a") -- rest of the file
	logfile:close()
	logfile = io.open(vim.lsp.log.get_filename(), "w+b")
	if logfile then
		logfile:write(remaining_lines)
		logfile:close()
	end
end

local function configure_lsp(lsp, cat, capabilities)
	-- if the category is disable in nixCats
	if not ncUtil.enableForCategory(cat, true) then
		return
	end
	local settings = lsp_settings[lsp] or {}
	if type(settings) == "function" then
		settings = lsp_settings[lsp]()
	end
	settings.capabilities = capabilities
	vim.lsp.config(lsp, settings)
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
			-- {
			-- 	mode = "n",
			-- 	"]d",
			-- 	function()
			-- 		vim.diagnostic.goto_next()
			-- 	end,
			-- 	options,
			-- },
			-- {
			-- 	mode = "n",
			-- 	"[d",
			-- 	function()
			-- 		vim.lsp.buf.
			-- 	end,
			-- 	options,
			-- },
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
			capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
		end
		if ncUtil.enableForCategory("luasnip", true) then
			capabilities.textDocument.completion.completionItem.snippetSupport = true
		end
		for lsp, cat in pairs(lsp_cats) do
			configure_lsp(lsp, cat, capabilities)
		end
		vim.lsp.log.set_level(vim.log.levels.WARN)
		vim.lsp.log.set_format_func(vim.inspect)

		if get_lsp_log_size() > lsp_log_size_thresh then
			shrink_lsp_log(lsp_log_size_ideal)
		end
	end,
}

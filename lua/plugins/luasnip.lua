return {
	"L3MON4D3/LuaSnip",
	name = "luasnip",
	lazy = false,
	enabled = require("nixCatsUtils").enableForCategory("luasnip", true),
	config = function()
		local ls = require("luasnip")
		require("luasnip.loaders.from_snipmate").lazy_load({ paths = "./lua/snippets/snipmate" })
		ls.setup()
	end,
	keys = function()
		local ls = require("luasnip")
		return {
			{
				mode = "i",
				"<Tab>",
				function()
					if ls.expand_or_jumpable() then
						ls.expand_or_jump()
					else
						local key = vim.api.nvim_replace_termcodes("<Tab>", true, false, true)
						vim.api.nvim_feedkeys(key, "n", true)
					end
				end,
			},
			{
				mode = { "i", "s" },
				"<C-c>",
				function()
					if vim.snippet then
						vim.snippet.stop()
					end
					vim.api.nvim_input("<Esc>")
				end,
			},
		}
	end,
}

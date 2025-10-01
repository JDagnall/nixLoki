local lua_print_table = [[
local function print_table(table, opts)
	local indent = opts.indent or 0
	local name = opts.name or ""
	if type(table) ~= "table" then
		return
	end
	if name ~= nil then
		print(string.rep("\t", indent), name, ": {")
	else
		print(string.rep("\t", indent), "{")
	end
	for k, v in pairs(table) do
		if type(v) == "table" then
			print_table(v, { indent = indent + 1, name = k })
		else
			print(string.rep("\t", indent + 1), k, ": ", v)
		end
	end
	print(string.rep("\t", indent), "}")
end
]]
-- split into list of lines
local lua_print_table_lines = {}
for line in lua_print_table:gmatch("([^\r\n]*)[\r\n]*") do
	table.insert(lua_print_table_lines, line)
end

return {
	"L3MON4D3/LuaSnip",
	name = "luasnip",
	lazy = false,
	enabled = require("nixCatsUtils").enableForCategory("luasnip", true),
	config = function()
		local ls = require("luasnip")
		local s = ls.snippet
		local t = ls.text_node
		local lua_print_table_snip = s({ trig = "print_table" }, { t(lua_print_table_lines) })
		ls.add_snippets("lua", { lua_print_table_snip })
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
		}
	end,
}

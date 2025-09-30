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
end $0
]]

return {
	"L3MON4D3/LuaSnip",
	lazy = false,
	enabled = require("nixCatsUtils").enableForCategory("luasnip", true),
	config = function()
		local ls = require("luasnip")
		local s = ls.snippet
		local fmt = require("luasnip.extras.fmt").fmt
		local lua_print_table_snip = s("print_table", fmt(lua_print_table))
		ls.add_snippets("lua", { lua_print_table_snip })
		ls.setup()
	end,
}

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

local nix_new_module = [[
{lib, config, ...}: let
    cfg = config.MODULE;
in {
    options = {
        MODULE = {
            enable = lib.mkEnableOption "Enable MODULE";
        };
    };
    config = lib.mkIf cfg.enable {
        MODULE = {
            enable = true;
        };
    };
}
]]

-- split into list of lines
local function into_lines(snippet)
	local lines = {}
	for line in snippet:gmatch("([^\r\n]*)[\r\n]*") do
		table.insert(lines, line)
	end
	return lines
end

local snippets = {
	{ snippet = into_lines(lua_print_table), lang = "lua", trig = "print_table" },
	{ snippet = into_lines(nix_new_module), lang = "nix", trig = "new_module" },
}

return {
	"L3MON4D3/LuaSnip",
	name = "luasnip",
	lazy = false,
	enabled = require("nixCatsUtils").enableForCategory("luasnip", true),
	config = function()
		local ls = require("luasnip")
		local s = ls.snippet
		local t = ls.text_node
		for _, snip in ipairs(snippets) do
			ls.add_snippets(snip.lang, { s({ trig = snip.trig }, { t(snip.snippet) }) })
		end
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

local nixCats = require("nixCats")
local piBinary = nixCats.extra("pi-binary") or "pi"
local piInstalled = true
-- If the command cannot be found
if not vim.fn.executable(piBinary) then
	piInstalled = false
end
-- check the program is in path
return {
	"pablopunk/pi.nvim",
	enabled = piInstalled and require("nixCatsUtils").enableForCategory("pi-nvim", true),
	lazy = true,
	opts = {
		-- binary = "", -- this should really be an option in nicCats Extra
		-- append_system_prompt = "",
		-- tools = {}, -- will use the default, but will always add read, write and edit because they are needed
		thinking = "off", -- better for this application
		-- skills = {},
		-- sessions = {},
		-- extensions = {},
	},
	keys = {
		{ "<leader>pi", "<cmd>PiAsk<CR>", mode = { "n" }, desc = "Feed the entire buffer to pi." },
		{ "<leader>pi", "<cmd>PiAskSelection<CR>", mode = { "v" }, desc = "Feed the visual selection to pi." },
	},
}

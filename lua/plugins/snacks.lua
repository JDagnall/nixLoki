local ncUtil = require("nixCatsUtils")

local get_config_path = function()
	if ncUtil.isNixCats then
		local nc = require("nixCats")
		return nc.configDir -- get the nix store config path if using nixCats (non test package)
	end
	return vim.fn.stdpath("config")
end
-- img file to use chafa to ascii art there are 4 pictures in the directory
-- ascii are is computed and saved in .ascii files because sometimes chafa can take a sec
-- chafa is still listed as a dependency in nix incase you want to make more
-- the chafa command is 'chafa -C true --symbols vhalf -f symbols -s 60x30 -O 9 --align left [img]'
-- '--align left' is important
local img_num = math.random(1, 4)
local img_file = get_config_path() .. "/img/loki/" .. img_num .. ".ascii"
return {
	"folke/snacks.nvim",
	enabled = ncUtil.enableForCategory("snacks", true),
	lazy = false,
	priority = 999,
	opts = {
		dashboard = {
			enabled = true,
			preset = {
				header = [[
███╗   ██╗██╗██╗  ██╗    ██╗      ██████╗ ██╗  ██╗██╗
████╗  ██║██║╚██╗██╔╝    ██║     ██╔═══██╗██║ ██╔╝██║
██╔██╗ ██║██║ ╚███╔╝     ██║     ██║   ██║█████╔╝ ██║
██║╚██╗██║██║ ██╔██╗     ██║     ██║   ██║██╔═██╗ ██║
██║ ╚████║██║██╔╝ ██╗    ███████╗╚██████╔╝██║  ██╗██║
╚═╝  ╚═══╝╚═╝╚═╝  ╚═╝    ╚══════╝ ╚═════╝ ╚═╝  ╚═╝╚═╝
                ]],
				keys = {
					{
						icon = "󰭎  ",
						desc = "Find Files",
						key = "a",
						action = ":Telescope find_files",
					},
					{
						icon = "  ",
						desc = "File Browser",
						key = "s",
						action = ":Ex",
					},
					{
						icon = "  ",
						desc = "Search CWD",
						key = "d",
						action = ":Telescope live_grep",
					},
					{
						icon = "  ",
						desc = "Recent Files",
						key = "f",
						action = ":Telescope oldfiles",
					},
					{
						icon = "󰒲  ",
						desc = "Lazy",
						key = "l",
						action = ":Lazy",
					},
					{
						icon = "󰈆  ",
						desc = "Quit",
						key = "q",
						action = ":q",
					},
				},
			},
			sections = {
				{
					section = "terminal",
					-- cmd = "chafa -C true --symbols vhalf -f symbols -s 60x30 -O 9 --align left " .. img_file .. "; sleep .1",
					cmd = "cat " .. img_file .. "; sleep .1",
					height = 30,
					padding = 1,
				},
				{
					pane = 2,
					{ section = "header" },
					{ section = "keys", gap = 1, padding = 1 },
					{ section = "startup" },
				},
			},
		},
		bigfile = { enabled = true },
		quickfile = { enabled = true },
		words = { enabled = false },
		scope = {
			enabled = true,
			keys = {
				jump = {
					["{"] = {
						min_size = 1, -- allow single line scopes
						bottom = false,
						cursor = true,
						edge = true,
						treesitter = { blocks = { enabled = false } },
						desc = "jump to top edge of scope",
					},
					["}"] = {
						min_size = 1, -- allow single line scopes
						bottom = true,
						cursor = true,
						edge = true,
						treesitter = { blocks = { enabled = false } },
						desc = "jump to bottom edge of scope",
					},
				},
			},
		},
	},
}

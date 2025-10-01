local ncUtil = require("nixCatsUtils")

vim.g.snacks_picker_enabled = ncUtil.enableForCategory("snacks", true) and true

local get_config_path = function()
	if ncUtil.isNixCats then
		local nc = require("nixCats")
		return nc.configDir -- get the nix store config path if using nixCats (non test package)
	end
	return vim.fn.stdpath("config")
end
-- img file to use chafa to ascii art there are 4 pictures in the directory
-- ascii are is computed and saved in .ascii files because sometimes chafa can take a sec
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
						action = function()
							if vim.g.telescope_enabled then
								require("telescope.builtin").find_files()
							elseif vim.g.snacks_picker_enabled then
								require("snacks").picker.files({ hidden = true, exclude = { "!**/.git/*" } })
							else
								print("No Picker Configured")
							end
						end,
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
						action = function()
							if vim.g.telescope_enabled then
								require("telescope.builtin").live_grep()
							elseif vim.g.snacks_picker_enabled then
								require("snacks").picker.grep()
							else
								print("No Picker Configured")
							end
						end,
					},
					{
						icon = "  ",
						desc = "Recent Files",
						key = "f",
						action = function()
							if vim.g.telescope_enabled then
								require("telescope.builtin").oldfiles()
							elseif vim.g.snacks_picker_enabled then
								require("snacks").picker.recent({ hidden = true, exclude = { "!**/.git/*" } })
							else
								print("No Picker Configured")
							end
						end,
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
		picker = {
			enabled = vim.g.snacks_picker_enabled,
			focus = "input",
			layout = {
				cycle = true,
				--- Use the default layout or vertical if the window is too narrow
				preset = function()
					return vim.o.columns >= 120 and "default" or "vertical"
				end,
			},
			matcher = {
				fuzzy = true,
				smartcase = true,
				ignorecase = true,
				sort_empty = false, -- sort results when the search string is empty
				filename_bonus = true, -- give bonus for matching file names (last part of the path)
				file_pos = true, -- support patterns like `file:line:col` and `file:line`
				-- the bonusses below, possibly require string concatenation and path normalization,
				-- so this can have a performance impact for large lists and increase memory usage
				cwd_bonus = false,
				frecency = false,
				history_bonus = false,
			},
			ui_select = true, -- replace `vim.ui.select` with the snacks picker
			formatters = {
				file = {
					filename_first = false,
					truncate = 40,
					filename_only = false,
					icon_width = 2,
					git_status_hl = true,
				},
			},
			previewers = {
				diff = {
					builtin = true,
					-- cmd = { "delta" }
				},
				git = {
					builtin = true,
					args = {},
				},
				file = {
					max_size = 1024 * 1024, -- 1MB
					max_line_length = 500,
					ft = nil,
				},
				man_pager = nil,
			},
			toggles = {
				follow = "f",
				hidden = "h",
				ignored = "i",
				modified = "m",
				regex = { icon = "R", value = false },
			},
			win = {
				input = {
					keys = {
						["<C-c>"] = { "cancel", mode = { "i", "n" } },
						["<C-U>"] = { "preview_scroll_up", mode = { "i", "n" } },
						["<C-D>"] = { "preview_scroll_down", mode = { "i", "n" } },
						["<C-H>"] = { "preview_scroll_left", mode = { "i", "n" } },
						["<C-J>"] = { "preview_scroll_down", mode = { "i", "n" } },
						["<C-K>"] = { "preview_scroll_up", mode = { "i", "n" } },
						["<C-L>"] = { "preview_scroll_right", mode = { "i", "n" } },
					},
				},
				list = {
					keys = {
						["<C-c>"] = { "cancel", mode = { "i", "n" } },
						-- ["<C-U>"] = { "preview_scroll_up", mode = { "i", "n" } },
						-- ["<C-D>"] = { "preview_scroll_down", mode = { "i", "n" } },
					},
				},
			},
		},
	},
	keys = function()
		if vim.g.snacks_picker_enabled == false then
			return {}
		end
		local Snacks = require("snacks")
		return {
			-- { "<leader>f", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
			{
				"<leader>pf",
				function()
					Snacks.picker.files({ hidden = true, exclude = { "!**/.git/*" } })
				end,
				desc = "Find Files",
			},
			{
				"<leader>ps",
				function()
					Snacks.picker.grep()
				end,
				desc = "Grep",
			},
			{
				"<leader>:",
				function()
					Snacks.picker.command_history()
				end,
				desc = "Command History",
			},
			{
				"<C-p>",
				function()
					Snacks.picker.git_files()
				end,
				desc = "Find Git Files",
			},
			{
				"<leader>gd",
				function()
					Snacks.picker.git_diff()
				end,
				desc = "Git Diff (Hunks)",
			},
			{
				"<leader>gb",
				function()
					Snacks.picker.git_branches()
				end,
				desc = "Git Branches",
			},
			{
				"<leader>gl",
				function()
					Snacks.picker.git_log()
				end,
				desc = "Git Log",
			},
			{
				"gr",
				function()
					Snacks.picker.lsp_references()
				end,
				nowait = true,
				desc = "References",
			},
			{
				"gI",
				function()
					Snacks.picker.lsp_implementations()
				end,
				desc = "Goto Implementation",
			},
			{
				"<leader>F",
				function()
					Snacks.picker.lsp_symbols({
						filter = {
							default = {
								"Function",
								"Class",
								"Constructor",
								"Method",
							},
						},
					})
				end,
				desc = "LSP Symbols",
			},
			{
				"<leader>t",
				function()
					Snacks.picker.pickers()
				end,
				desc = "List all pickers",
			},
		}
	end,
}

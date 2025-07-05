local ncUtil = require("nixCatsUtils")
-- nixCats utilites return default values if not on a nix system
-- enableForCategory: checks a category specification in the nixCats nix config
-- or returns the specified default value if not on a nix system

local colors = require("catppuccin.palettes")

local function diff_source()
	local gitsigns = vim.b.gitsigns_status_dict
	if gitsigns then
		return {
			added = gitsigns.added,
			modified = gitsigns.changed,
			removed = gitsigns.removed,
		}
	end
end

local gitsigns_diff = {
	"diff",
	source = diff_source(),
	symbols = {
		added = " ",
		modified = "󱗜 ",
		removed = " ",
	},
}

local gitsigns_branch = { "b:gitsigns_head", icon = " " }

local EOL_format = {
	"fileformat",
	icons_enabled = true,
	symbols = {
		unix = "LF",
		dos = "CRLF",
		mac = "CR",
	},
}

local filename = {
	"filename",
	path = 1,
	file_status = true,
	newfile_status = true,
	shorting_target = 40,
	symbols = {
		modified = " ",
		readonly = "󱀰 ",
		unnamed = "[No Name]",
		newfile = "[New]",
	},
}

local harpoon = {
	"harpoon2",
	icon = "󰀱 ",
	no_harpoon = "",
}

local diagnostics = {
	"diagnostics",
	sources = { "nvim_diagnostic" },
	sections = { "error", "warn", "info", "hint" },
	symbols = { error = "󰅙 ", warn = " ", info = " ", hint = " " },
	colored = true,
	update_in_insert = false,
	always_visible = false,
}

return {
	"nvim-lualine/lualine.nvim",
    enabled = ncUtil.enableForCategory("lualine", true),
	dependencies = {
		{
			"letieu/harpoon-lualine",
            enabled = ncUtil.enableForCategory("lualine.harpoon", true),
			dependencies = {
				{
					"ThePrimeagen/harpoon",
					branch = ncUtil.lazyAdd("harpoon2", nil),
				},
			},
		},
		{
			-- Allows displaying git blames among other things
			"lewis6991/gitsigns.nvim",
            enabled = ncUtil.enableForCategory("lualine.gitsigns", true),
			opts = {
				signs_staged_enable = true,
				signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
				numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
				linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
				word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
			},
		},
	},
	opts = {
		options = {
			theme = "catppuccin",
			component_separators = { left = "", right = "" },
			section_separators = { right = "", left = "" },
			globalstatus = true,
		},
		sections = {
			lualine_a = {
				{ "mode" },
			},
			lualine_b = ncUtil.enableForCategory("lualine.gitsigns", true) and {
				gitsigns_branch,
				gitsigns_diff,
			} or {},
			lualine_c = {
				filename,
				diagnostics,
			},
			lualine_x = ncUtil.enableForCategory("lualine.harpoon", true) and {
				harpoon,
			} or {},
			lualine_y = {
				{ "lsp_status" },
				{ "filetype" },
				{ "encoding" },
				EOL_format,
			},
			lualine_z = {
				{ "location" },
				{ "progress" },
			},
		},
	},
}

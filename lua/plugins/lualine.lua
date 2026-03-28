local ncUtil = require("nixCatsUtils")
-- nixCats utilites return default values if not on a nix system

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

local gitsigns_branch = {
	"b:gitsigns_head",
	icon = " ",
	max_length = vim.o.columns / 3,
}

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

local diagnostics = {
	"diagnostics",
	sources = { "nvim_diagnostic" },
	sections = { "error", "warn", "info", "hint" },
	symbols = { error = "󰅙 ", warn = " ", info = " ", hint = " " },
	colored = true,
	update_in_insert = false,
	always_visible = false,
}

-- create lualine theme table from a base16 colour scheme
local function create_lualine_theme(base16)
	local lualine_colours = {
		bg = base16.base01,
		alt_bg = base16.base02,
		dark_fg = base16.base03,
		fg = base16.base04,
		light_fg = base16.base05,
		normal = base16.base0D,
		insert = base16.base0B,
		visual = base16.base0E,
		replace = base16.base09,
	}
	local theme = {
		normal = {
			a = { fg = lualine_colours.bg, bg = lualine_colours.normal },
			b = { fg = lualine_colours.light_fg, bg = lualine_colours.alt_bg },
			c = { fg = lualine_colours.fg, bg = lualine_colours.bg },
		},
		replace = {
			a = { fg = lualine_colours.bg, bg = lualine_colours.replace },
			b = { fg = lualine_colours.light_fg, bg = lualine_colours.alt_bg },
		},
		insert = {
			a = { fg = lualine_colours.bg, bg = lualine_colours.insert },
			b = { fg = lualine_colours.light_fg, bg = lualine_colours.alt_bg },
		},
		visual = {
			a = { fg = lualine_colours.bg, bg = lualine_colours.visual },
			b = { fg = lualine_colours.light_fg, bg = lualine_colours.alt_bg },
		},
		inactive = {
			a = { fg = lualine_colours.dark_fg, bg = lualine_colours.bg },
			b = { fg = lualine_colours.dark_fg, bg = lualine_colours.bg },
			c = { fg = lualine_colours.dark_fg, bg = lualine_colours.bg },
		},
	}
	theme.command = theme.normal
	theme.terminal = theme.insert
	return theme
end

return {
	"nvim-lualine/lualine.nvim",
	enabled = ncUtil.enableForCategory("lualine", true),
	dependencies = {
		"lewis6991/gitsigns.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	opts = {
		options = {
			theme = function()
				if ncUtil.enableForCategory("cattpuccin", true) then
					return "cattpuccin"
				elseif ncUtil.enableForCategory("tinted-nvim") then
					-- lualine does not work directly with tinted-nvim as it did
					-- previously, so just make the theme object as it does in lualine
					-- manually
					local base16 = require("tinted-nvim").get_palette()
					if base16 == nil then
						print("Lualine: unable to get base16 palette from tinted-nvim")
						return "auto"
					end
					return create_lualine_theme(base16)
				elseif ncUtil.enableForCategory("mini-base16") then
					-- lualine does not work directly with tinted-nvim, so just
					-- make the theme object as it does in lualine manually
					local base16 = require("mini-base16").palette
					if base16 == nil then
						print("Lualine: unable to get base16 palette from mini-base16")
						return "auto"
					end
					return create_lualine_theme(base16)
				else
					return "auto"
				end
			end,
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
			lualine_x = {},
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

local function config()
	local feline = require("feline")

	local palette = require("catppuccin.palettes")

	local catpuccin_mocha = palette.get_palette()
	catpuccin_mocha.bg = catpuccin_mocha.mantle
	catpuccin_mocha.fg = catpuccin_mocha.text

	local colors = {
		fg = "text",
		bg = "mantle",
		bg_lighter = "surface0",
		git_branch = "flamingo",
		git_added = "green",
		git_removed = "maroon",
		git_changed = "yellow",
		error = "maroon",
		warning = "yellow",
		hint = "sapphire",
		lsp = "mauve",
		file_type = "maroon",
		encoding = "peach",
		position = "green",
		scroll_percentage = "sapphire",
		scroll_bar = "yellow",
	}

	local vi_mode_colors = {
		NORMAL = "green",
		OP = "green",
		INSERT = "yellow",
		VISUAL = "mauve",
		LINES = "peach",
		BLOCK = "red",
		REPLACE = "maroon",
		COMMAND = "sapphire",
	}

	local c = {
		vim_mode = {
			provider = {
				name = "vi_mode",
				opts = {
					show_mode_name = true,
					-- padding = "center", -- Uncomment for extra padding.
				},
			},
			hl = function()
				return {
					fg = require("feline.providers.vi_mode").get_mode_color(),
					bg = colors.bg_lighter,
					style = "bold",
					name = "NeovimModeHLColor",
				}
			end,
			left_sep = "block",
			right_sep = "right_rounded",
		},
		gitBranch = {
			provider = "git_branch",
			hl = {
				fg = colors.git_branch,
				bg = colors.bg_lighter,
				style = "bold",
			},
			left_sep = "",
			right_sep = "",
			truncate_hide = true,
		},
		gitDiffAdded = {
			provider = "git_diff_added",
			hl = {
				fg = colors.git_added,
				bg = colors.bg_lighter,
			},
			left_sep = "block",
			right_sep = "block",
			truncate_hide = true,
		},
		gitDiffRemoved = {
			provider = "git_diff_removed",
			hl = {
				fg = colors.git_removed,
				bg = colors.bg_lighter,
			},
			left_sep = "block",
			right_sep = "block",
			truncate_hide = true,
		},
		gitDiffChanged = {
			provider = "git_diff_changed",
			hl = {
				fg = colors.git_changed,
				bg = colors.bg_lighter,
			},
			left_sep = "block",
			right_sep = "",
			icon = "󱗜 ",
			truncate_hide = true,
		},
		separator = {
			provider = " ",
		},
		git_separator = {
			provider = " ",
			enabled = is_git_info,
		},
		separator_lighter = {
			provider = " ",
			hl = {
				bg = colors.bg_lighter,
			},
		},
		git_spacer_left = {
			provider = " ",
			enabled = is_git_info,
			hl = {
				fg = colors.fg,

				bg = colors.bg_lighter,
			},
			left_sep = "left_rounded",
			right_sep = "",
		},
		git_spacer_right = {
			provider = " ",
			enabled = is_git_info,
			hl = {
				fg = colors.fg,

				bg = colors.bg_lighter,
			},
			left_sep = "",
			right_sep = "right_rounded",
		},
		spacer_left = {
			provider = " ",
			hl = {
				fg = colors.fg,

				bg = colors.bg_lighter,
			},
			left_sep = "left_rounded",
			right_sep = "block",
		},
		spacer_right = {
			provider = " ",
			hl = {
				fg = colors.fg,

				bg = colors.bg_lighter,
			},
			left_sep = "block",
			right_sep = "right_rounded",
		},
		fileinfo = {
			provider = {
				name = "file_info",
				opts = {
					type = "relative",
				},
			},
			hl = {
				style = "bold",
			},
			left_sep = " ",
			right_sep = " ",
			truncate_hide = true,
		},
		diagnostic_errors = {
			provider = "diagnostic_errors",
			hl = {
				fg = colors.error,
			},
			truncate_hide = true,
		},
		diagnostic_warnings = {
			provider = "diagnostic_warnings",
			hl = {
				fg = colors.warning,
			},
			truncate_hide = true,
		},
		diagnostic_hints = {
			provider = "diagnostic_hints",
			hl = {
				fg = colors.hint,
			},
			truncate_hide = true,
		},
		diagnostic_info = {
			provider = "diagnostic_info",
			truncate_hide = true,
		},
		lsp_client_names = {
			provider = "lsp_client_names",
			hl = {
				fg = colors.lsp,
				bg = colors.bg_lighter,
				style = "bold",
			},
			left_sep = "block",
			right_sep = "block",
		},
		file_type = {
			provider = {
				name = "file_type",
				opts = {
					filetype_icon = true,
					case = "titlecase",
				},
			},
			hl = {
				fg = colors.file,
				bg = colors.bg_lighter,
				style = "bold",
			},
			left_sep = "block",
			right_sep = "block",
			truncate_hide = true,
		},
		file_encoding = {
			provider = "file_encoding",
			hl = {
				fg = colors.encoding,
				bg = colors.bg_lighter,
				style = "bold",
			},
			left_sep = "block",
			right_sep = "block",
			truncate_hide = true,
		},
		position = {
			provider = "position",
			hl = {
				fg = colors.position,
				bg = colors.bg_lighter,
				style = "bold",
			},
			left_sep = "block",
			right_sep = "block",
			truncate_hide = true,
		},
		line_percentage = {
			provider = "line_percentage",
			hl = {
				fg = colors.scroll_percentage,
				bg = colors.bg_lighter,
				style = "bold",
			},
			left_sep = "block",
			right_sep = "block",
			truncate_hide = true,
		},
		scroll_bar = {
			provider = "scroll_bar",
			hl = {
				fg = colors.scroll_bar,
				style = "bold",
			},
			truncate_hide = true,
		},
	}

	local left = {
		c.vim_mode,
		c.git_separator,
		c.git_spacer_left,
		c.gitBranch,
		c.gitDiffAdded,
		c.gitDiffRemoved,
		c.gitDiffChanged,
		c.git_spacer_right,
		c.separator,
		c.fileinfo,
		c.separator,
		c.diagnostic_errors,
		c.diagnostic_warnings,
		c.diagnostic_info,
		c.diagnostic_hints,
	}

	local middle = {}

	local right = {
		c.spacer_left,
		c.lsp_client_names,
		c.file_type,
		c.file_encoding,
		c.position,
		c.line_percentage,
		c.scroll_bar,
	}

	local components = {
		active = {
			left,
			middle,
			right,
		},
		inactive = {
			left,
			middle,
			right,
		},
	}

	feline.setup({
		components = components,
		theme = catpuccin_mocha,
		vi_mode_colors = vi_mode_colors,
	})
end

-- Status Line
return {
	"feline-nvim/feline.nvim",
	enabled = require("nixCatsUtils").enableForCategory("feline", false),
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		{
			-- Allows displaying git blames among other things, is used by feline for the git components
			"lewis6991/gitsigns.nvim",
			opts = {
				signs_staged_enable = true,
				signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
				numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
				linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
				word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
			},
		},
	},
	config = config,
}

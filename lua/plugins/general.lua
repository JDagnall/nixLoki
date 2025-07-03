-- nixCats utilites return default values if not on a nix system
-- enableForCategory: checks a category specification in the nixCats nix config
-- or returns the specified default value if not on a nix system
local ncUtil = require("nixCatsUtils")

-- all one-liner / no config plugins go here
return {
		-- required for lazy.nvim and image.nvim
		{
			"vhyrro/luarocks.nvim",
			priority = 1001, -- this plugin needs to run before anything else
			opts = {
				rocks = { "magick" },
			},
			config = true,
            enabled = ncUtil.enableForCategory("luarocks", true),
		},
		-- surround text, Visual: s[char], Normal: cs[char][char], S[char]
		{ 
            "tpope/vim-surround",
            enabled = ncUtil.enableForCategory("vim-surround", true),
        },
		-- Game
		-- { 'ThePrimeagen/vim-be-good' }
		-- Makes transparent
		{ 
            "xiyaowong/transparent.nvim",
            enabled = ncUtil.enableForCategory("transparent", true),
        },
		-- Comments blocks: gbc, lines: gcc
		{ 
            "numToStr/Comment.nvim",
            enabled = ncUtil.enableForCategory("comment", true),
        },
		{ 
            "nvim-tree/nvim-web-devicons", lazy = true,
            enabled = ncUtil.enableForCategory("web-devicons", true),
        },
		-- tmux pane navigation integration (ctrl-[hjkl])
		{ 
            "christoomey/vim-tmux-navigator",
            enabled = ncUtil.enableForCategory("vim-tmux-navigator", false),
        },
		-- Wezterm image provider
		{ 
            "willothy/wezterm.nvim", config = true, enabled = false,
            enabled = ncUtil.enableForCategory("wezterm", true),
        },
		-- netrw glow up
		{
			"prichrd/netrw.nvim",
			opts = {},
			dependencies = { "nvim-tree/nvim-web-devicons" },
            enabled = ncUtil.enableForCategory("netrw", true),
		},
		{
			"RRethy/vim-illuminate",
			config = function()
				require("illuminate").configure({
					modes_allowlist = { "n" },
					providers = { "lsp" },
				})
			end,
            enabled = ncUtil.enableForCategory("vim-illuminate", true),
		},
		-- { 
            -- "vuciv/golf", 
            -- enabled = ncUtil.enableForCategory("golf", false),
        -- },
}

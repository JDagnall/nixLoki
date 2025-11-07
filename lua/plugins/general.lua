-- nixCats utilites return default values if not on a nix system
-- enableForCategory: checks a category specification in the nixCats nix config
-- or returns the specified default value if not on a nix system
local ncUtil = require("nixCatsUtils")
-- TODO: find a way to manager nixCats enabling and disabling plugins in one place

-- all one-liner / no config plugins go here
return {
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
		"nvim-tree/nvim-web-devicons",
		lazy = true,
		enabled = ncUtil.enableForCategory("web-devicons", true),
	},
	-- tmux pane navigation integration (ctrl-[hjkl])
	{
		"christoomey/vim-tmux-navigator",
		enabled = ncUtil.enableForCategory("vim-tmux-navigator", false),
	},
	-- netrw glow up
	{
		"prichrd/netrw.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		enabled = ncUtil.enableForCategory("netrw", true),
		opts = {},
	},
	-- {
	-- "vuciv/golf",
	-- enabled = ncUtil.enableForCategory("golf", false),
	-- },
}

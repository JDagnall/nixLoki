local ncUtil = require("nixCatsUtils")
-- nixCats utilites return default values if not on a nix system
-- enableForCategory: checks a category specification in the nixCats nix config
-- or returns the specified default value if not on a nix system
-- lazyAdd: returns the first specified value if not on a nix system
-- and the second if currently configured by nixCats

return {
	"ThePrimeagen/harpoon",
	enabled = ncUtil.enableForCategory("harpoon", true),
	branch = ncUtil.lazyAdd("harpoon2", nil),
	dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
	keys = function()
		local harpoon = require("harpoon")
		-- pcall(require("telescope").load_extension, "harpoon")
		return {
			{
				mode = "n",
				"<leader>a",
				function()
					harpoon:list():add()
				end,
				desc = "Add to harpoon list",
			},
			{
				mode = "n",
				"<leader>r",
				function()
					harpoon:list():remove()
				end,
				desc = "Remove from harpoon list",
			},
			{
				mode = "n",
				"<C-S-h>",
				function()
					harpoon.ui:toggle_quick_menu(harpoon:list())
				end,
				desc = "View harppon list",
			},
			-- {
			-- 	mode = "n",
			-- 	"<C-S-h>",
			-- 	":Telescope harpoon",
			-- 	desc = "View harppon list",
			-- },
			{
				mode = "n",
				"<C-,>",
				function()
					harpoon:list():prev()
				end,
				desc = "Harpoon previous",
			},
			{
				mode = "n",
				"<C-.>",
				function()
					harpoon:list():next()
				end,
				desc = "Harpoon Next",
			},
		}
	end,
	opts = {},
}

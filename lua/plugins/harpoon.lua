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
		return {
			{
				mode = "n",
				"<A-a>",
				function()
					harpoon:list():add()
				end,
				desc = "Add to harpoon list",
			},
			{
				mode = "n",
				"<A-d>",
				function()
					harpoon:list():remove()
				end,
				desc = "Remove from harpoon list",
			},
			{
				mode = "n",
				"<A-h>",
				":HarpoonTelescope<CR>",
				desc = "View harpoon telescope list",
			},
			{
				mode = "n",
				"<A-H>",
				":HarpoonList<CR>",
				desc = "View harpoon editable list",
			},
			{
				mode = "n",
				"<A-,>",
				function()
					harpoon:list():prev()
				end,
				desc = "Harpoon previous",
			},
			{
				mode = "n",
				"<A-.>",
				function()
					harpoon:list():next()
				end,
				desc = "Harpoon Next",
			},
		}
	end,
	lazy = false,
	opts = {},
	config = function(_, opts)
		local harpoon = require("harpoon")
		harpoon.setup(opts)
		vim.api.nvim_create_user_command("HarpoonList", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, {})

		-- basic telescope configuration
		local telescope_conf = require("telescope.config").values
		local function toggle_telescope(harpoon_files)
			local file_paths = {}
			for _, item in ipairs(harpoon_files.items) do
				table.insert(file_paths, item.value)
			end

			require("telescope.pickers")
				.new({}, {
					prompt_title = "Harpoon",
					finder = require("telescope.finders").new_table({
						results = file_paths,
					}),
					previewer = telescope_conf.file_previewer({}),
					sorter = telescope_conf.generic_sorter({}),
				})
				:find()
		end
		vim.api.nvim_create_user_command("HarpoonTelescope", function()
			toggle_telescope(harpoon:list())
		end, {})
	end,
}

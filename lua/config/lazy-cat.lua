-- lazyCat is a wrapper around lazy-nvim that passes information such as
-- plugin paths to lazy, on non nix systems is does nothing

-- gives default values for nixCats functions in
-- require('nixCatsUtils').setup {
--   non_nix_value = true,
-- }
local ncUtil = require("nixCatsUtils")

local function getlockfilepath()
	if ncUtil.isNixCats and type(nixCats.settings.unwrappedCfgPath) == "string" then
		return nixCats.settings.unwrappedCfgPath .. "/lazy-lock.json"
	else -- if not on a nix system set the regular lock file path
		return vim.fn.stdpath("config") .. "/lazy-lock.json"
	end
end

-- Options that would be passed to lazy-nvim normally
local lazyOptions = {
	lockfile = getlockfilepath(),
	defaults = {
		lazy = false,
		version = false,
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = {
		colorscheme = { "catppuccin" },
		missing = not ncUtil.isNixCats,
	},
	-- automatically check for plugin updates
	checker = {
		enabled = not ncUtil.isNixCats,
		notify = false,
	},
	change_detection = {
		enabled = true, -- works on nix?
		notify = false,
	},
	performance = {
		rtp = {
			disabled_plugins = {},
		},
	},
}

-- NOTE: this the lazy wrapper. Use it like require('lazy').setup() but with an extra
-- argument, the path to lazy.nvim as downloaded by nix, or nil, before the normal arguments.
require("nixCatsUtils.lazyCat").setup(nixCats.pawsible({ "allPlugins", "start", "lazy.nvim" }), { -- spec
	{ import = "plugins" },
}, lazyOptions)

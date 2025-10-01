inputs: let
	inherit (inputs.nixCats) utils;
	# package settings shared between loki nvim packages
	loki_settings = {...}:
	# @misc
	{
		# unwrappedCfgPath = utils.mkLuaInline "(os.getenv('XDG_CONFIG_HOME') or '/home/james/.config') .. '/loki'";
		wrapRc = true;
		# whether runtime dependencies will overwrite existing dependencies or the inverse
		# appends runtime dependencies to the end of the PATH not the start
		suffix-path = true;
		# appends sharedLibraries to the end of the LD_LIBRARY_PATH not the start
		suffix-LD = true;
		# neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
		hosts.python3.enable = true;
		# hosts.node.enable = true;
		# groups treesitter into the same directory
		collate-grammars = true;
		# neovim-unwrapped = null; pin a specific nvim version
		# nvimSRC = null; # causes it to build from source
	};
	# enabled categories shared between loki nvim packages
	# All categories included must be marked true, but false may be omitted.
	# This entire set is also passed to nixCats for querying within the lua.
	# see :help nixCats.flake.outputs.packageDefinitions
	loki_cats = {...}:
	# @misc
	{
		general = true;
		# plugins
		lualine.lualine = true;
		lualine.harpoon = true;
		lualine.gitsigns = true;
		catppuccin = true;
		treesitter = true;
		lspconfig = true;
		conform = true;
		trouble = true;
		cmp = true;
		telescope = false;
		mini-indentscope = true;
		vim-surround = true;
		transparent = true;
		comment = true;
		web-devicons = true;
		netrw = true;
		vim-illuminate = true;
		ts-autotag = true;
		harpoon = true;
		snacks = true;
		autopairs = true;
		smart-splits = true;
		toggleterm = true;
		iron = true;
		undotree = true;
		vim-fugitive = true;
		yanky = true;
		luasnip = true;

		# langs
		lang.lua = true;
		lang.nix = true;
		lang.go = true;
		lang.c = true;
		lang.python = true;
		lang.bash = true;
		lang.jinja = true;
		lang.css = true;
		lang.html = true;
		lang.toml = true;
		lang.markdown = true;
		lang.javascript = true;
		lang.json = true;
	};
	# extra specifications shared between loki nvim packages
	loki_extra = {...}:
	# @misc
	{
		theme = "catppuccin";
	};
in {
	nixLoki = {
		# pkgs,
		# name,
		# mkPlugin,
		...
	} @ args: {
		# see :help nixCats.flake.outputs.settings
		settings =
			loki_settings args
			// {
				# aliases may not conflict with your other packages.
				aliases = [
					"loki"
					"nvim"
				];
				configDirName = "loki";
				extraName = "nixLoki";
			};
		categories = loki_cats args // {};
		# things to pass to nvim that aren't categories
		extra = loki_extra args // {};
	};
	# an extra test package with normal lua reload for fast edits
	# nix doesnt provide the config in this package, allowing free reign to edit it.
	testNixLoki = {
		# pkgs,
		# name,
		# mkPlugin,
		...
	} @ args: {
		settings =
			loki_settings args
			// {
				wrapRc = false;
				unwrappedCfgPath = utils.mkLuaInline "(os.getenv('XDG_CONFIG_HOME') or '/home/james/.config') .. '/testLoki'";
				configDirName = "testLoki";
				extraName = "testNixLoki";
			};
		categories = loki_cats args // {};
		extra = loki_extra args // {};
	};
}

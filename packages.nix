inputs: let
    inherit (inputs.nixCats) utils;
    # package settings shared between loki nvim packages
    loki_settings = { pkgs, ... }@misc: {
        extraName = "nixLoki";
        configDirName = "loki";
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
    loki_cats = { pkgs, ... }@misc: {
          general = true;   
          # plugins
          lualine.lualine = true;
          lualine.gitsigns = true;
          catppuccin =  true;
          treesitter = true;
          # langs
          lang.lua = true;
          lang.nix = true;
    };
    # extra specifications shared between loki nvim packages
    loki_extra = { pkgs, ... }@misc: {
        theme = "catppuccin";
    };
in {
    nixLoki = { pkgs, name, mkPlugin, ... }@args: {
        # see :help nixCats.flake.outputs.settings
        settings = loki_settings args // {
          # aliases may not conflict with your other packages.
          aliases = [ "loki" ];
        };
        categories = loki_cats args // {};
        # things to pass to nvim that aren't categories
        extra = loki_extra args // {};
    };
    # an extra test package with normal lua reload for fast edits
    # nix doesnt provide the config in this package, allowing free reign to edit it.
    testNixLoki = { pkgs, mkPlugin, ... }@args: {
        settings = loki_settings args // {
            wrapRc = false; 
            unwrappedCfgPath = utils.mkLuaInline "os.getenv('XDG_CONFIG_HOME') .. 'testLoki'";
        };
        categories = loki_cats args // {};
        extra = loki_extra args // {};
    };
}:

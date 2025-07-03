{
  description = "Neovim configuration, compatible with nix and non-nix systems. Thanks Loki.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";
    # neovim-nightly-overlay = {
    #   url = "github:nix-community/neovim-nightly-overlay";
    # };
    # see :help nixCats.flake.inputs
    # If you want your plugin to be loaded by the standard overlay,
    # i.e. if it wasnt on nixpkgs, but doesnt have an extra build step.
  };

  # see :help nixCats.flake.outputs
  outputs = { self, nixpkgs, nixCats, ... }@inputs: let
    inherit (nixCats) utils;
    luaPath = ./.; # lua configuration is in this same directory
    forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
    extra_pkg_config = {
      # allowUnfree = true;
    };

    dependencyOverlays = [
      # use `pkgs.neovimPlugins`, which is a set of our plugins.
      (utils.standardPluginOverlay inputs)
      # add any other flake overlays here.
    ];

    # see :help nixCats.flake.outputs
    categoryDefinitions = { pkgs, settings, categories, extra, name, mkPlugin, ... }@packageDef: {

      # this section is for dependencies that should be available at RUN TIME
      lspsAndRuntimeDeps = with pkgs; {
        general = [ ];
        telescope = [
            ripgrep
            fd
            # gnumake # dont actually need unless planning to build fzf-native
        ];
        treesitter = [ ];
        lang = {
            lua = [ lua-language-server stylua ];
            go = [ gopls go ];
            nix = [ nixd nixfmt-rfc-style ];
            c = [ clang-tools ];
            python = [ ruff autopep8 python312Packages.python-lsp-server ];
            bash = [ shfmt ];
            jinja = [ djlint ];
        };
      };

      # lazy doesnt care if these are in startupPlugins or optionalPlugins
      startupPlugins = with pkgs.vimPlugins; {
        # should always be turned on
        general = [
          lazy-nvim
        ];
        treesitter = [
          nvim-treesitter-textobjects
          nvim-treesitter.withAllGrammars
          # if you only want some of the grammars
          # (nvim-treesitter.withPlugins (
          #   plugins: with plugins; [
          #     nix
          #     lua
          #   ]
          # ))
        ];
        lualine = {
            lualine = [ lualine-nvim ];
            harpoon = [ harpoon2  plenary-nvim ];
            gitsigns = [ gitsigns-nvim ];
        };
        conform = [ conform-nvim ];
        catppuccin = [
          # sometimes you have to fix some names
          { plugin = catppuccin-nvim; name = "catppuccin"; }
        ];
        mini-indentscope = [
          # sometimes you have to fix some names
          { plugin = mini-indentscope; name = "mini.indentscope"; }
        ];
        lspconfig = [ nvim-lspconfig ];
        ts-autotag = [ nvim-ts-autotag ];
        telescope = [
          plenary-nvim
          telescope-fzf-native-nvim
          telescope-ui-select
          telescope-nvim
        ];
        trouble = [ trouble-nvim nvim-web-devicons ];
        harpoon = [
            harpoon2
            plenary
            telescope-nvim
        ];
        vim-illuminate = [ vim-illuminate ];
        netrw = [ netrw-nvim nvim-web-devicons ];
        transparent  = [ transparent-nvim ];
        snacks = [ snacks-nvim ];
        cmp = [
            nvim-cmp
            cmp-path
            cmp-buffer
        ];
        comment = [ comment-nvim ];
        luarocks = [ rocks-nvim ];
        autopairs = [ nvim-autopairs ];
        smart-splits = [ smart-splits-nvim ];
        toggleterm = [ toggleterm-nvim ];
        vim-surround = [ vim-surround ];
        tmux-navigator = [ vim-tmux-navigator ];
        iron = [ iron-nvim ];
        undotree = [ undotree ];
        vim-fugitive = [ vim-fugitive ];
        yanky = [ yanky-nvim telescope-nvim ];
        dashboard = [ dashboard-nvim nvim-web-devicons];
        feline = [ nvim-web-devicons ]; # is not in nix, diabled anyway, could use git call to get it
        molten = [ molten-nvim ];
        wezterm = [ wezterm-nvim ];
        image = [ image-nvim rocks-nvim ];
        jupytext = [ jupytext-nvim ];
        noice = [ noice-nvim nvim-notify nui-nvim ];
      };

      # lazy doesnt care if these are in startupPlugins or optionalPlugins
      optionalPlugins = {};

      # shared libraries to be added to LD_LIBRARY_PATH variable. available to nvim runtime
      sharedLibraries = {
        # general = with pkgs; [ ];
      };

      # at RUN TIME for plugins. Will be available to path within neovim terminal
      environmentVariables = { };

      # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
      extraWrapperArgs = { };

      # lists of the functions you would have passed to
      # python.withPackages or lua.withPackages

      # get the path to this python environment: vim.g.python3_host_prog
      # or run from nvim terminal via :!<packagename>-python3
      python3.libraries = { };
      # populates $LUA_PATH and $LUA_CPATH
      extraLuaPackages = { };
    };



    # All categories included must be marked true, but false may be omitted.
    # This entire set is also passed to nixCats for querying within the lua.
    # see :help nixCats.flake.outputs.packageDefinitions
    packageDefinitions = {
      nixLoki = { pkgs, name, mkPlugin, ... }: {
        # see :help nixCats.flake.outputs.settings
        settings = {
          suffix-path = true;
          suffix-LD = true;
          wrapRc = false;
          # aliases may not conflict with your other packages.
          aliases = [ "loki" ];
          # neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
          hosts.python3.enable = true;
          # hosts.node.enable = true;
        };
        # categories to enable
        categories = {
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
        # things to pass to nvim that aren't categories
        extra = { theme = "catppuccin"; };
      };
      # an extra test package with normal lua reload for fast edits
      # nix doesnt provide the config in this package, allowing free reign to edit it.
      testNixLoki = { pkgs, mkPlugin, ... }: {
        settings = {
          suffix-path = true;
          suffix-LD = true;
          # relevant settings, stops the lua from being stored in the store
          wrapRc = false; 
          unwrappedCfgPath = utils.mkLuaInline "os.getenv('HOME') .. '/some/path/to/your/config'";
        };
        categories = {
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
        extra = { theme = "catppuccin"; };
      };
    };
    defaultPackageName = "nixLoki";
  in


  # see :help nixCats.flake.outputs.exports
  forEachSystem (system: let
    # the builder function that makes it all work
    nixCatsBuilder = utils.baseBuilder luaPath {
      inherit nixpkgs system dependencyOverlays extra_pkg_config;
    } categoryDefinitions packageDefinitions;
    defaultPackage = nixCatsBuilder defaultPackageName;
    # this is just for using utils such as pkgs.mkShell
    # The one used to build neovim is resolved inside the builder
    # and is passed to our categoryDefinitions and packageDefinitions
    pkgs = import nixpkgs { inherit system; };
  in
  {
    # these outputs will be wrapped with ${system} by utils.eachSystem

    # this will make a package out of each of the packageDefinitions defined above
    # and set the default package to the one passed in here.
    packages = utils.mkAllWithDefault defaultPackage;

    # choose your package for devShell
    # and add whatever else you want in it.
    devShells = {
      default = pkgs.mkShell {
        name = defaultPackageName;
        packages = [ defaultPackage ];
        inputsFrom = [ ];
        shellHook = ''
        '';
      };
    };

  }) // (let
    # we also export a nixos module to allow reconfiguration from configuration.nix
    nixosModule = utils.mkNixosModules {
      moduleNamespace = [ defaultPackageName ];
      inherit defaultPackageName dependencyOverlays luaPath
        categoryDefinitions packageDefinitions extra_pkg_config nixpkgs;
    };
    # and the same for home manager
    homeModule = utils.mkHomeModules {
      moduleNamespace = [ defaultPackageName ];
      inherit defaultPackageName dependencyOverlays luaPath
        categoryDefinitions packageDefinitions extra_pkg_config nixpkgs;
    };
  in {

    # these outputs will be NOT wrapped with ${system}

    # this will make an overlay out of each of the packageDefinitions defined above
    # and set the default overlay to the one named here.
    overlays = utils.makeOverlays luaPath {
      inherit nixpkgs dependencyOverlays extra_pkg_config;
    } categoryDefinitions packageDefinitions defaultPackageName;

    nixosModules.default = nixosModule;
    homeModules.default = homeModule;

    inherit utils nixosModule homeModule;
    inherit (utils) templates;
  });
}

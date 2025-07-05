# see :help nixCats.flake.outputs
inputs:
let
    # inherit (inputs.nixCats) utils;
in
{
    pkgs,
    # settings,
    # categories,
    # extra,
    # name,
    # mkPlugin,
    ...
} # @packageDef
:
{
    # this section is for dependencies that should be available at RUN TIME
    lspsAndRuntimeDeps = with pkgs; {
        general = [ ];
        telescope = [
            ripgrep
            # fd
            # gnumake # dont actually need unless planning to build fzf-native
            file
        ];
        treesitter = [ ];
        snacks = [ chafa ];
        lang = {
            lua = [
                lua-language-server
                stylua
            ];
            go = [
                gopls
                go
            ];
            nix = [
                nixd
                nixfmt-rfc-style
            ];
            c = [ clang-tools ];
            python = [
                ruff
                python312Packages.autopep8
                python312Packages.python-lsp-server
            ];
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
            harpoon = [
                {plugin = harpoon2; name = "harpoon";}
                pkgs.neovimPlugins.harpoon-lualine
                plenary-nvim
            ];
            gitsigns = [ gitsigns-nvim ];
        };
        conform = [ conform-nvim ];
        catppuccin = [
            # sometimes you have to fix some names
            {
                plugin = catppuccin-nvim;
                name = "catppuccin";
            }
        ];
        mini-indentscope = [
            # sometimes you have to fix some names
            {
                plugin = mini-indentscope;
                name = "mini.indentscope";
            }
        ];
        lspconfig = [ nvim-lspconfig ];
        ts-autotag = [ nvim-ts-autotag ];
        telescope = [
            plenary-nvim
            telescope-fzf-native-nvim
            telescope-ui-select-nvim
            telescope-nvim
        ];
        trouble = [
            trouble-nvim
            nvim-web-devicons
        ];
        harpoon = [
            # harpoon2
            {plugin = harpoon2; name = "harpoon";}
            plenary-nvim
            telescope-nvim
        ];
        vim-illuminate = [ vim-illuminate ];
        netrw = [
            netrw-nvim
            nvim-web-devicons
        ];
        transparent = [ transparent-nvim ];
        snacks = [ snacks-nvim ];
        cmp = [
            nvim-cmp
            cmp-path
            cmp-buffer
            cmp-nvim-lsp
        ];
        comment = [
            {
                plugin = comment-nvim;
                name = "Comment.nvim";
            }
        ];
        luarocks = [ rocks-nvim ];
        autopairs = [ nvim-autopairs ];
        smart-splits = [ smart-splits-nvim ];
        toggleterm = [ toggleterm-nvim ];
        vim-surround = [ vim-surround ];
        tmux-navigator = [ vim-tmux-navigator ];
        iron = [ iron-nvim ];
        undotree = [ undotree ];
        vim-fugitive = [ vim-fugitive ];
        yanky = [
            yanky-nvim
            telescope-nvim
        ];
        dashboard = [
            dashboard-nvim
            nvim-web-devicons
        ];
        feline = [ nvim-web-devicons ]; # is not in nix, diabled anyway, could use git call to get it
        molten = [ molten-nvim ];
        wezterm = [ wezterm-nvim ];
        image = [
            image-nvim
            rocks-nvim
        ];
        jupytext = [ jupytext-nvim ];
        noice = [
            noice-nvim
            nvim-notify
            nui-nvim
        ];
    };

    # lazy doesnt care if these are in startupPlugins or optionalPlugins
    optionalPlugins = { };

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
}

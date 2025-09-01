{ config, lib, ... }@args:
let
  inputs = args.inputs;
  utils = inputs.nixCats.utils;
in
{
  imports = [ inputs.nixCats.nixosModules.default ];

  config.nixCats = {
    enable = true;
    addOverlays = [ (utils.standardPluginOverlay inputs) ];
	luaPath = ../nixvim;
    packageNames = [ "myNixModuleNvim" ];

    categoryDefinitions.replace = { pkgs, ... }: {
      lspsAndRuntimeDeps = {
        general = with pkgs; [
          lua-language-server
          rust-analyzer
          nil # for Nix LSP
        ];
      };
      startupPlugins.general = with pkgs.vimPlugins; [
        nvim-treesitter.withAllGrammars
        telescope-nvim
        lualine-nvim
        nvim-cmp
        cmp-nvim-lsp
        cmp-buffer
        cmp-path
        luasnip
        cmp_luasnip
        nvim-lspconfig
        gruvbox-nvim
        catppuccin-nvim
      ];
      optionalPlugins.general = [ ];
      sharedLibraries.general = [ ];
      environmentVariables.test = {
        CATTESTVAR = "It worked!";
      };
      extraWrapperArgs.test = [
        '' --set CATTESTVAR2 "It worked again!"''
      ];
    };

    packageDefinitions.replace = {
      myNixModuleNvim = { pkgs, ... }: {
        settings = {
          wrapRc = true;
          suffix-path = true;
          suffix-LD = true;
          aliases = [ "nvim" ];
	  unwrappedCfgPath = "/home/oscar/.config/nvim";
        };
        categories = {
          general = true;
        };
      };
    };
  };
}


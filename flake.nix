{
  description = "A simple NixOS flake";

  inputs = {
    nixpkgs.url          = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    musnix.url           = "github:musnix/musnix";
    nixCats.url          = "github:BirdeeHub/nixCats-nvim";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, musnix, nixCats, ... }@inputs:
  let
    system = "x86_64-linux";
  in {

    overlays = {
      unstable-packages = final: _prev: {
        unstable = import nixpkgs-unstable {
          inherit (final) system;
          config.allowUnfree = true;
        };
      };
    };

    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          { nixpkgs.overlays = [ self.overlays.unstable-packages ]; }
          musnix.nixosModules.musnix
          ./hosts/station/configuration.nix
          ./modules/nvidia.nix
          ./modules/nixCats-nvim.nix
        ];
      };

      nixpad = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/thinkpad/configuration.nix
        ];
      };

      nixserver = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/server/configuration.nix
          ./modules/media_server.nix
        ];
      };

    };
  };
}

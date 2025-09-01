{
  description = "A simple NixOS flake";

  inputs = {
    # NixOS official package source
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    musnix  = { url = "github:musnix/musnix"; };
    nixCats.url = "github:BirdeeHub/nixCats-nvim";
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      # Inject inputs so modules can access them
      specialArgs = { inherit inputs; };

      modules = [
         inputs.musnix.nixosModules.musnix
        ./hosts/station/configuration.nix
        ./modules/nvidia.nix
        ./modules/nixCats-nvim.nix
      ];
    };

    nixosConfigurations.nixpad = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/thinkpad/configuration.nix
      ];
    };

    nixosConfigurations.nixserver = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/server/configuration.nix
        ./modules/media_server.nix
      ];
    };
  };
}

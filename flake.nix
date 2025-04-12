{
  description = "A simple NixOS flake";

  inputs = {
    # NixOS official package source
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    musnix  = { url = "github:musnix/musnix"; };

  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
         inputs.musnix.nixosModules.musnix
        ./hosts/station/configuration.nix
        ./modules/nvidia.nix
      ];
    };

    nixosConfigurations.nixpad = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/thinkpad/configuration.nix
      ];
    };
  };
}

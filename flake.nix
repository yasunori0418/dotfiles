{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    xremap.url = "github:xremap/nix-flake";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixos-hardware,
    xremap,
    home-manager,
  } @ inputs: let
    system = "x86_64-linux";
  in {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
    nixosConfigurations = {
      laptop = nixpkgs.lib.nixosSystem {
        system = system;
        modules = [
          ./nixos/ThinkPadE14Gen2
          nixos-hardware.nixosModules.lenovo-thinkpad-e14-amd
          xremap.nixosModules.default
        ];
      };
    };

    homeConfigurations = {
      linux = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = system;
          config.allowUnfree = true;
        };
        extraSpecialArgs = {
          inherit inputs;
        };
        modules = [
          ./home/linux.nix
        ];
      };
    };
  };
}

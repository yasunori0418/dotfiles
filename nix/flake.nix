{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    xremap.url = "github:xremap/nix-flake";
  };

  outputs = {self, nixpkgs, nixos-hardware, xremap }: {
    nixosConfigurations = {
      laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./laptop/configuration.nix
          nixos-hardware.nixosModules.lenovo-thinkpad-e14-amd
        ];
        specialArgs = {
          inherit nixpkgs;
          inherit nixos-hardware;
          inherit xremap;
        };
      };
    };
  };
}

{
  description = "My dotfiles, all my wisdom, my castle.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    xremap-flake = {
      url = "github:xremap/nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wezterm-flake = {
      url = "github:wez/wezterm?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-hardware,
      xremap-flake,
      home-manager,
      wezterm-flake,
    }:
    let
      flake_root = ./.;
      nixos = /${flake_root}/nixos;
      nixosModules = /${nixos}/modules;
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
      nixosConfigurations = {
        laptop = nixpkgs.lib.nixosSystem (
          import ./nixos/ThinkPadE14Gen2 {
            inherit nixos-hardware  nixosModules xremap-flake;
          }
        );
        desktop = nixpkgs.lib.nixosSystem (
          import ./nixos/Desktop {
            inherit nixos-hardware  nixosModules xremap-flake;
          }
        );
      };

      homeConfigurations = {
        linux = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config.allowUnfree = true;
            overlays =
              let
                sheldonOverlay = import ./nix-overlays/sheldon.nix;
              in
              [
                sheldonOverlay
              ];
          };
          extraSpecialArgs = {
            inherit wezterm-flake;
          };
          modules = [ ./home-manager/linux.nix ];
        };
      };
    };
}

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
      flakeRoot = ./.;
      nixpkgsOverlay = /${flakeRoot}/nix-overlays;

      # nixos directory symbols
      nixos = /${flakeRoot}/nixos;
      nixosModules = /${nixos}/modules;

      # nix home-manager directory symbols
      homeManager = /${flakeRoot}/home-manager;
      xdgConfigHome = /${flakeRoot}/config;
      homeDir = /${flakeRoot}/home;
      appleLibrary = /${flakeRoot}/Library;
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
      nixosConfigurations = {
        laptop = nixpkgs.lib.nixosSystem (
          import ./nixos/ThinkPadE14Gen2 {
            inherit nixos-hardware nixosModules xremap-flake;
          }
        );
        desktop = nixpkgs.lib.nixosSystem (
          import ./nixos/Desktop {
            inherit nixos-hardware nixosModules xremap-flake;
          }
        );
      };

      homeConfigurations = {
        linux = home-manager.lib.homeManagerConfiguration (
          import ./home-manager {
            profileName = "linux";
            system = "x86_64-linux";
            inherit
              nixpkgs
              wezterm-flake
              flakeRoot
              nixpkgsOverlay
              homeManager
              xdgConfigHome
              homeDir
              appleLibrary
              ;
          }
        );
      };
    };
}

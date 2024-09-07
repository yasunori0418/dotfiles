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
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
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
      neovim-nightly-overlay,
    }:
    let
      flakeRoot = ./.;
      nixpkgsOverlay = /${flakeRoot}/nix-overlays;

      # nixos directory symbols
      nixos = /${flakeRoot}/nixos;
      nixosSettings = /${nixos}/settings;

      # nix home-manager directory symbols
      homeManager = /${flakeRoot}/home-manager;
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
      formatter.x86_64-darwin = nixpkgs.legacyPackages.x86_64-darwin.nixfmt-rfc-style;
      nixosConfigurations = {
        laptop = nixpkgs.lib.nixosSystem (
          import ./nixos/ThinkPadE14Gen2 {
            inherit nixos-hardware  xremap-flake nixosSettings;
          }
        );
        desktop = nixpkgs.lib.nixosSystem (
          import ./nixos/Desktop {
            inherit nixos-hardware  xremap-flake nixosSettings;
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
              neovim-nightly-overlay
              flakeRoot
              nixpkgsOverlay
              homeManager
              ;
          }
        );
        macx64 = home-manager.lib.homeManagerConfiguration (
          import ./home-manager {
            profileName = "macx64";
            system = "x86_64-darwin";
            inherit
              nixpkgs
              wezterm-flake
              neovim-nightly-overlay
              flakeRoot
              nixpkgsOverlay
              homeManager
              ;
          }
        );
      };
    };
}

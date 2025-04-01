{
  description = "My dotfiles, all my wisdom, my castle.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    devenv.url = "github:cachix/devenv";
    systems.url = "github:nix-systems/default";
    mk-shell-bin.url = "github:rrbutani/nix-mk-shell-bin";
    nix2container = {
      url = "github:nlewo/nix2container";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xremap-flake = {
      url = "github:xremap/nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vim-overlay = {
      url = "github:kawarimidoll/vim-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      # self,
      flake-parts,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { withSystem, flake-parts-lib, ... }:
      let
        # ref: https://flake.parts/dogfood-a-reusable-module.html?highlight=imports#example-with-importapply
        importApply =
          nixPath:
          let
            inherit (flake-parts-lib) importApply;
          in
          importApply nixPath { inherit withSystem; };
      in
      {
        imports =
          let
            treefmt.default = importApply ./flake-parts/treefmt.nix;
            devenv.default = importApply ./flake-parts/devenv.nix;
          in
          [
            inputs.treefmt-nix.flakeModule
            treefmt.default
            inputs.devenv.flakeModule
            devenv.default
          ];
        systems = import inputs.systems;
        flake = {
          nixosConfigurations =
            let
              inherit (inputs.nixpkgs.lib) nixosSystem;
              inherit (import ./nixos/args.nix inputs) args;
            in
            {
              laptop = nixosSystem (args {
                profileName = "ThinkPadE14Gen2";
                system = "x86_64-linux";
              });
              desktop = nixosSystem (args {
                profileName = "Desktop";
                system = "x86_64-linux";
              });
              macx64OrbStack = nixosSystem (args {
                profileName = "MacX64_OrbStack";
                system = "x86_64-linux";
              });
            };

          homeConfigurations =
            let
              inherit (inputs.home-manager.lib) homeManagerConfiguration;
              inherit (import ./home-manager/args.nix inputs) args;
            in
            {
              linux = homeManagerConfiguration (args {
                profileName = "linux";
                system = "x86_64-linux";
              });
              macx64 = homeManagerConfiguration (args {
                profileName = "macx64";
                system = "aarch64-darwin";
              });
            };
        };
      }
    );
}

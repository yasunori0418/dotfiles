{
  description = "My dotfiles, all my wisdom, my castle.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    flake-parts.url = "github:hercules-ci/flake-parts";
    treefmt-nix.url = "github:numtide/treefmt-nix";
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
        inherit (flake-parts-lib) importApply;
        importApp = nixPath: importApply nixPath { inherit withSystem; };
      in
      {
        imports =
          let
            treefmt.default = importApp ./flake-parts/treefmt.nix;
          in
          [
            inputs.treefmt-nix.flakeModule
            treefmt.default
          ];
        systems = [
          "x86_64-linux"
          "aarch64-linux"
          "aarch64-darwin"
          "x86_64-darwin"
        ];
        flake = {
          nixosConfigurations =
            let
              nixosSystemArgs =
                { profileName, system }:
                import ./nixos {
                  inherit
                    inputs
                    profileName
                    system
                    ;
                };
              inherit (inputs.nixpkgs.lib) nixosSystem;
            in
            {
              laptop = nixosSystem (nixosSystemArgs {
                profileName = "ThinkPadE14Gen2";
                system = "x86_64-linux";
              });
              desktop = nixosSystem (nixosSystemArgs {
                profileName = "Desktop";
                system = "x86_64-linux";
              });
              macx64OrbStack = nixosSystem (nixosSystemArgs {
                profileName = "MacX64_OrbStack";
                system = "x86_64-linux";
              });
            };

          homeConfigurations =
            let
              inherit (inputs.home-manager.lib) homeManagerConfiguration;
              inherit (import ./home-manager/args.nix) args;
            in
            {
              linux = homeManagerConfiguration (args {
                inherit inputs;
                profileName = "linux";
                system = "x86_64-linux";
              });
              macx64 = homeManagerConfiguration (args {
                inherit inputs;
                profileName = "macx64";
                system = "x86_64-darwin";
              });
            };
        };
      }
    );
}

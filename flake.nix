{
  description = "My dotfiles, all my wisdom, my castle.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    flake-parts.url = "github:hercules-ci/flake-parts";
    nix-monitored = {
      url = "github:ners/nix-monitored";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    claude-desktop = {
      url = "github:k3d3/claude-desktop-linux-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    devenv = {
      url = "github:cachix/devenv";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    systems.url = "github:nix-systems/default";
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
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
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
        flake =
          let
            args =
              targetSystem:
              let
                f =
                  { profileName, system }:
                  import ./${targetSystem} {
                    inherit inputs profileName system;
                  };
              in
              f;
          in
          {
            nixosConfigurations =
              let
                inherit (inputs.nixpkgs.lib) nixosSystem;
                nixosArgs = args "nixos";
                system = "x86_64-linux";
              in
              {
                yasunori-laptop = nixosSystem (nixosArgs {
                  profileName = "ThinkPadE14Gen2";
                  inherit system;
                });
                yasunori-desktop = nixosSystem (nixosArgs {
                  profileName = "Desktop";
                  inherit system;
                });
                macx64OrbStack = nixosSystem (nixosArgs {
                  profileName = "MacX64_OrbStack";
                  inherit system;
                });
              };

            homeConfigurations =
              let
                inherit (inputs.home-manager.lib) homeManagerConfiguration;
                hmArgs = args "home-manager";
              in
              {
                linux = homeManagerConfiguration (hmArgs {
                  profileName = "linux";
                  system = "x86_64-linux";
                });
                macos = homeManagerConfiguration (hmArgs {
                  profileName = "macos";
                  system = "aarch64-darwin";
                });
              };

            darwinConfigurations =
              let
                inherit (inputs.nix-darwin.lib) darwinSystem;
                darwinArgs = args "nix-darwin";
                system = "aarch64-darwin";
              in
              {
                LGPM-0151 = darwinSystem (darwinArgs {
                  profileName = "lg-darwin";
                  inherit system;
                });
              };

          };
      }
    );
}

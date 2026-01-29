{
  description = "My dotfiles, all my wisdom, my castle.";

  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/70801e06d9730c4f1704fbd3bbf5b8e11c03a2a7";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    flake-parts.url = "github:hercules-ci/flake-parts";
    mac-app-util.url = "github:hraban/mac-app-util";
    yasunori-nur = {
      url = "github:yasunori0418/nur-packages";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.treefmt-nix.follows = "treefmt-nix";
    };
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
    mk-shell-bin.url = "github:rrbutani/nix-mk-shell-bin";
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
    llm-agents-nix = {
      url = "github:numtide/llm-agents.nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.treefmt-nix.follows = "treefmt-nix";
    };
    claude-code-overlay = {
      url = "github:ryoppippi/claude-code-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zmx.url = "github:neurosnap/zmx";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    vim-overlay.url = "github:kawarimidoll/vim-overlay";
  };

  nixConfig = {
    extra-substituters = [
      "https://cache.nixos.org/"
      "https://nix-community.cachix.org"
      "https://devenv.cachix.org"
      "https://cache.numtide.com"
      "https://yasunori0418.cachix.org"
      "https://ryoppippi.cachix.org"
    ];

    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
      "yasunori0418.cachix.org-1:mC1j+M5A6063OHaOB5bH2nS0BiCW/BJsSRiOWjLeV9o="
        "ryoppippi.cachix.org-1:b2LbtWNvJeL/qb1B6TYOMK+apaCps4SCbzlPRfSQIms="
    ];
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
                yasunori-laptop2 = nixosSystem (nixosArgs {
                  profileName = "ThinkPadP14sGen6";
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
                iso = nixosSystem {
                  inherit system;
                  modules = [
                    "${inputs.nixpkgs.outPath}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
                    ./nixos/iso
                  ];
                };
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

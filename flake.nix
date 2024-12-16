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
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        # To import a flake module
        # 1. Add foo to inputs
        # 2. Add foo as a parameter to the outputs function
        # 3. Add here: foo.flakeModule
        inputs.treefmt-nix.flakeModule
      ];
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      perSystem =
        {
          # config,
          # self',
          # inputs',
          # pkgs,
          # system,
          ...
        }:
        {
          treefmt = {
            programs = {
              beautysh = {
                enable = true;
                indent_size = 4;
              };
              nixfmt-rfc-style.enable = true;
              stylua = {
                enable = true;
                settings = {
                  call_parentheses = "Always";
                  collapse_simple_statement = "Never";
                  column_width = 120;
                  indent_type = "Spaces";
                  indent_width = 4;
                  line_endings = "Unix";
                  quote_style = "AutoPreferDouble";
                  sort_requires.enabled = false;
                };
              };
              deno = {
                enable = true;
                includes = [
                  "home/.config/nvim"
                  "home/.config/vim"
                ];
              };
            };
          };
          # Per-system attributes can be defined here. The self' and inputs'
          # module parameters provide easy access to attributes of the same
          # system.
        };
      flake = {
        # The usual flake attributes can be defined here, including system-
        # agnostic ones like nixosModule and system-enumerating ones, although
        # those are more easily expressed in perSystem.

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
    };
}

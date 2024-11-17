{
  description = "My dotfiles, all my wisdom, my castle.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
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
      nixpkgs,
      ...
    }@inputs:
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
      formatter.x86_64-darwin = nixpkgs.legacyPackages.x86_64-darwin.nixfmt-rfc-style;
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
          homeManagerArgs =
            { profileName, system }:
            import ./home-manager {
              inherit
                profileName
                system
                ;
              inherit (inputs)
                nixpkgs
                neovim-nightly-overlay
                vim-overlay
                ;
            };
          inherit (inputs.home-manager.lib) homeManagerConfiguration;
        in
        {
          linux = homeManagerConfiguration (homeManagerArgs {
            profileName = "linux";
            system = "x86_64-linux";
          });
          macx64 = homeManagerConfiguration (homeManagerArgs {
            profileName = "macx64";
            system = "x86_64-darwin";
          });
        };
    };
}

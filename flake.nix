{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    xremap = {
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
      xremap,
      home-manager,
      wezterm-flake,
    }:
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
      nixosConfigurations = {
        laptop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./nixos/ThinkPadE14Gen2
            nixos-hardware.nixosModules.lenovo-thinkpad-e14-amd
            xremap.nixosModules.default
          ];
        };
        desktop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules =
            [
              ./nixos/Desktop
              xremap.nixosModules.default
            ]
            ++ (with nixos-hardware.nixosModules; [
              common-cpu-amd-zenpower
              common-gpu-nvidia-sync
              common-pc-ssd
            ]);
        };
      };

      homeConfigurations = {
        linux = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
          extraSpecialArgs = {
            inherit wezterm-flake;
          };
          modules = [ ./home-manager/linux.nix ];
        };
      };
    };
}

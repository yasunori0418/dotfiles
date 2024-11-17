{
  inputs,
  nixos-hardware,
  xremap-flake,
  profileName,
  system,
  ...
}:
{
  inherit system;
  specialArgs = {
    inherit
      inputs
      system
      nixos-hardware
      xremap-flake
      ;
  };
  modules = [
    ./${profileName}
    inputs.home-manager.nixosModules.home-manager
    (
      let
        homeManagerConfig = import ../home-manager {
          profileName = "linux";
          inherit system;
          inherit (inputs)
            nixpkgs
            wezterm-flake
            neovim-nightly-overlay
            vim-overlay
            ;
        };
      in
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.yasunori = {
            imports = homeManagerConfig.modules;
          };
          inherit (homeManagerConfig) extraSpecialArgs;
        };
      }
    )
  ];
}

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
  modules =
    let
      hmNixosModule = inputs.home-manager.nixosModules.home-manager;
      homeConfig = import ./home.nix { inherit inputs system; };
    in
    [
      ./${profileName}
      hmNixosModule
      homeConfig
    ];
}

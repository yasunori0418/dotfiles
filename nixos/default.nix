{
  inputs,
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
      ;
    inherit (inputs)
      nixos-hardware
      xremap-flake
      ;
  };
  modules =
    let
      inherit (inputs.home-manager.nixosModules) home-manager;
      homeConfig = import ./home.nix { inherit inputs system; };
    in
    [
      ./${profileName}
      home-manager
      homeConfig
    ];
}

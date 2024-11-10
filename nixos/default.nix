{
  nixos-hardware,
  xremap-flake,
  nixosSettings,
  nixpkgsOverlay,
  profileName,
  system,
  ...
}:
{
  inherit system;
  specialArgs = {
    inherit
      nixos-hardware
      nixosSettings
      nixpkgsOverlay
      xremap-flake
      ;
  };
  modules = [
    ./${profileName}
  ];
}

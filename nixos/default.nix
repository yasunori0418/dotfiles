{
  nixos-hardware,
  xremap-flake,
  nixosSettings,
  profileName,
  system,
  ...
}:
{
  inherit system;
  specialArgs = {
    inherit nixos-hardware nixosSettings xremap-flake;
  };
  modules = [
    ./${profileName}
  ];
}

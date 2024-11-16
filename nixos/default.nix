{
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
      nixos-hardware
      xremap-flake
      ;
  };
  modules = [
    ./${profileName}
  ];
}

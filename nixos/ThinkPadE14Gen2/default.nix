{
  nixosSettings,
  nixos-hardware,
  xremap-flake,
  ...
}:
{
  system = "x86_64-linux";
  specialArgs = {
    inherit nixosSettings nixos-hardware xremap-flake;
  };
  modules = [
    ./configuration.nix
  ];
}

{
  nixos-hardware,
  xremap-flake,
  nixosSettings,
  ...
}:
{
  system = "x86_64-linux";
  specialArgs = {
    inherit nixos-hardware nixosSettings xremap-flake;
  };
  modules = [
    ./configuration.nix
  ];
}

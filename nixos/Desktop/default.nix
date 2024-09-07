{
  nixos-hardware,
  xremap-flake,
  nixosSettings,
  ...
}:
{
  system = "x86_64-linux";
  specialArgs = {
    inherit nixos-hardware nixosSettings;
  };
  modules = [
    ./configuration.nix
    xremap-flake.nixosModules.default
  ];
}

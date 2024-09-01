{
  nixos-hardware,
  xremap,
  nixosModules,
  ...
}:
{
  system = "x86_64-linux";
  specialArgs = {
    inherit nixos-hardware nixosModules;
  };
  modules =
    [
      ./configuration.nix
      xremap.nixosModules.default
    ];
}

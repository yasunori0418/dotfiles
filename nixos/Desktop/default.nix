{
  nixos-hardware,
  xremap-flake,
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
      xremap-flake.nixosModules.default
    ];
}

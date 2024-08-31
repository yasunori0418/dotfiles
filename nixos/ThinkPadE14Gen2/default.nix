{
  nixosModules,
  nixos-hardware,
  xremap,
  ...
}:
{
  system = "x86_64-linux";
  specialArgs = {
    inherit nixosModules;
  };
  modules = [
    ./configuration.nix
    nixos-hardware.nixosModules.lenovo-thinkpad-e14-amd
    xremap.nixosModules.default
  ];
}

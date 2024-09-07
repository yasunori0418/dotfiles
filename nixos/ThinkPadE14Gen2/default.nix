{
  nixosSettings,
  nixos-hardware,
  xremap-flake,
  ...
}:
{
  system = "x86_64-linux";
  specialArgs = {
    inherit nixosSettings;
  };
  modules = [
    ./configuration.nix
    nixos-hardware.nixosModules.lenovo-thinkpad-e14-amd
    xremap-flake.nixosModules.default
  ];
}

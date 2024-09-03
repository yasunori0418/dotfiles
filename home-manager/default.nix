{
  profileName,
  system,
  nixpkgs,
  wezterm-flake,
  flakeRoot,
  homeManager,
  nixpkgsOverlay,
  ...
}:
{
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
    overlays = [
      (import /${nixpkgsOverlay}/sheldon.nix)
    ];
  };
  extraSpecialArgs = {
    inherit
      wezterm-flake
      flakeRoot
      homeManager
      ;
  };
  modules = [ ./${profileName} ];
}

{
  profileName,
  system,
  nixpkgs,
  wezterm-flake,
  flakeRoot,
  homeManager,
  # nixpkgsOverlay,
  ...
}:
{
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
    config.allowUnsupportedSystem = true;
    overlays = [];
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

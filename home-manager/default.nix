{
  profileName,
  system,
  nixpkgs,
  wezterm-flake,
  flakeRoot,
  homeManager,
  nixpkgsOverlay,
  xdgConfigHome,
  homeDir,
  appleLibrary,
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
      xdgConfigHome
      homeDir
      appleLibrary
      ;
  };
  modules = [ ./${profileName} ];
}

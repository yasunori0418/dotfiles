{
  profileName,
  system,
  nixpkgs,
  wezterm-flake,
  flakeRoot,
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
      xdgConfigHome
      homeDir
      appleLibrary
      ;
  };
  modules = [ ./${profileName} ];
}

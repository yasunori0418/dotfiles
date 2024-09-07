{
  profileName,
  system,
  nixpkgs,
  wezterm-flake,
  neovim-nightly-overlay,
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
    overlays = [
      neovim-nightly-overlay.overlays.default
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

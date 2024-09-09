{
  profileName,
  system,
  nixpkgs,
  wezterm-flake,
  neovim-nightly-overlay,
  vim-overlay,
  flakeRoot,
  homeManager,
  # nixpkgsOverlay,
  ...
}:
{
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
    overlays = [
      neovim-nightly-overlay.overlays.default
      (vim-overlay.overlays.features {
        lua = true;
        python3 = true;
        ruby = true;
        sodium = true;
      })
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

{
  profileName,
  system,
  nixpkgs,
  wezterm-flake,
  neovim-nightly-overlay,
  vim-overlay,
  homeManager,
  nixpkgsOverlay,
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
      (import "${nixpkgsOverlay}/gnu-screen.nix")
    ];
  };
  extraSpecialArgs = {
    inherit
      wezterm-flake
      homeManager
      ;
  };
  modules = [ ./${profileName} ];
}

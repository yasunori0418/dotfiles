{
  profileName,
  system,
  nixpkgs,
  neovim-nightly-overlay,
  vim-overlay,
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
      (import ../nix-overlays/gnu-screen.nix)
    ];
  };
  extraSpecialArgs = { };
  modules = [ ./${profileName} ];
}

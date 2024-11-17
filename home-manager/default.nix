{
  profileName,
  system,
  nixpkgs,
  nixpkgs-stable,
  neovim-nightly-overlay,
  vim-overlay,
  ...
}:
let
  pkgs-stable = import nixpkgs-stable {
    inherit system;
    config.allowUnfree = true;
  };
in
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
  extraSpecialArgs = {
    inherit pkgs-stable;
  };
  modules = [ ./${profileName} ];
}

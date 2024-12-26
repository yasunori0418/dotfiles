{ inputs, ... }:
let
  inherit (inputs)
    neovim-nightly-overlay
    vim-overlay
    ;
in
{
  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      neovim-nightly-overlay.overlays.default
      (vim-overlay.overlays.features {
        lua = true;
        python3 = true;
        ruby = true;
        sodium = true;
      })
      (import ../../nix-overlays/awscli2.nix)
    ];
  };
}

inputs:
let
  inherit (inputs)
    neovim-nightly-overlay
    vim-overlay
    ;
in
[
  neovim-nightly-overlay.overlays.default
  (vim-overlay.overlays.features {
    lua = true;
    python3 = true;
    ruby = true;
    sodium = true;
  })
  # (import ./hoge.nix)
]

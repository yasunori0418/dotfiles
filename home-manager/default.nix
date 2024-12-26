{
  inputs,
  profileName,
  system,
  ...
}:
let
  inherit (inputs)
    nixpkgs
    nixpkgs-stable
    ;
  pkgs-stable = import nixpkgs-stable {
    inherit system;
    config.allowUnfree = true;
  };
in
{
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
    overlays =
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
      ];
  };
  extraSpecialArgs = {
    inherit pkgs-stable;
  };
  modules = [ ./${profileName} ];
}

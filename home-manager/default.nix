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
    overlays = [
      inputs.claude-code-overlay.overlays.default
      (inputs.vim-overlay.overlays.features {
        lua = true;
        python3 = true;
        ruby = true;
        sodium = true;
      })
    ];
  };
  extraSpecialArgs = {
    inherit
      inputs
      pkgs-stable
      ;
  };
  modules = [ ./${profileName} ];
}

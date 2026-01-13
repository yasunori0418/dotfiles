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
    overlays = [ inputs.claude-code-overlay.overlays.default ];
  };
in
{
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };
  extraSpecialArgs = {
    inherit
      inputs
      pkgs-stable
      ;
  };
  modules = [ ./${profileName} ];
}

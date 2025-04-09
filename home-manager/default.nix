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
    claude-desktop
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
    overlays = import ../nix-overlays inputs;
  };
  extraSpecialArgs = {
    inherit pkgs-stable claude-desktop;
  };
  modules = [ ./${profileName} ];
}

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
      (import ../nix-overlays/clipcat.nix)
      (import ../nix-overlays/curl.nix)
    ];
  };
  extraSpecialArgs = {
    inherit
      inputs
      pkgs-stable
      ;
  };
  modules = [
    ./${profileName}
    inputs.nix-index-database.homeModules.default
    inputs.layat.homeManagerModules.default
  ];
}

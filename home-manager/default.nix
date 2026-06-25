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
    overlays = [ ];
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
    inputs.nput.homeManagerModules.default
  ];
}

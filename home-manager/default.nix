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
  nodePkgsBuilder =
    pkgs:
    pkgs.callPackages ../node2nix {
      inherit pkgs;
      inherit (pkgs) system;
      nodejs = pkgs.nodejs_24;
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
      nodePkgsBuilder
      ;
  };
  modules = [ ./${profileName} ];
}

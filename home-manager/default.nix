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
  nodePkgsBuilder = pkgs: pkgs.callPackages ../node2nix { inherit pkgs; };
in
{
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
  };
  extraSpecialArgs = {
    inherit inputs pkgs-stable claude-desktop nodePkgsBuilder;
  };
  modules = [ ./${profileName} ];
}

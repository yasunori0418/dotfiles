{
  inputs,
  profileName,
  system,
  ...
}:
let
  inherit (inputs)
    nixpkgs-stable
    ;
  pkgs-stable = import nixpkgs-stable {
    inherit system;
    config.allowUnfree = true;
  };
in
{
  inherit system;
  specialArgs = {
    inherit pkgs-stable;
  };
  modules = [ ./${profileName} ];
}

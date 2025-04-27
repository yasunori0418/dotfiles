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
  modules =
    let
      inherit (import ../home-manager/args.nix inputs) hmConfigForNixDarwinModules;
      home-manager = hmConfigForNixDarwinModules system;
    in
    [
      ./${profileName}
    ]
    ++ home-manager;
}

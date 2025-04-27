{
  inputs,
  profileName,
  system,
  ...
}:
{
  inherit system;
  specialArgs = {
    inherit
      inputs
      system
      ;
    inherit (inputs)
      nixos-hardware
      xremap-flake
      ;
  };
  modules =
    let
      inherit (import ../home-manager/args.nix inputs) hmConfigForNixosModule;
      home-manager = hmConfigForNixosModule system;
    in
    [
      ./${profileName}
    ]
    ++ home-manager;
}

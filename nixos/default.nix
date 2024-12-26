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
      inherit (inputs.home-manager.nixosModules) home-manager;
      inherit (import ../home-manager/args.nix inputs) hmConfigForNixosModule;
      homeConfig = hmConfigForNixosModule system;
    in
    [
      ./${profileName}
      home-manager
      homeConfig
    ];
}

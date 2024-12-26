inputs: rec {
  args =
    { profileName, system }:
    import ./default.nix {
      inherit inputs profileName system;
    };
  hmConfigForNixosModule =
    system:
    let
      homeManagerConfig = args {
        profileName = "linux";
        inherit system;
      };
    in
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "hm_backup";
        users.yasunori = {
          imports = homeManagerConfig.modules;
        };
        inherit (homeManagerConfig) extraSpecialArgs;
      };
    };
}

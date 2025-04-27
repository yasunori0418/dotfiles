inputs: rec {
  args =
    { profileName, system }:
    import ./default.nix {
      inherit inputs profileName system;
    };
  hmConfigForModule =
    {
      system,
      profileName,
      username,
      moduleName,
    }:
    let
      homeManagerConfig = args {
        inherit profileName system;
      };
      inherit (inputs.home-manager.${moduleName}) home-manager;
    in
    [
      home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          backupFileExtension = "hm_backup";
          users.${username} = {
            imports = homeManagerConfig.modules;
          };
          inherit (homeManagerConfig) extraSpecialArgs;
        };
      }
    ];
  hmConfigForNixosModule =
    system:
    let
      username = "yasunori";
      profileName = "linux";
      moduleName = "nixosModules";
    in
    hmConfigForModule {
      inherit
        system
        profileName
        username
        moduleName
        ;
    };
  hmConfigForNixDarwinModules =
    system:
    let
      username = "taiki.watanabe";
      profileName = "macx64";
      moduleName = "darwinModules";
    in
    hmConfigForModule {
      inherit
        system
        profileName
        username
        moduleName
        ;
    };
}

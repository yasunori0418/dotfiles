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
    hmConfigForModule {
      username = "yasunori";
      profileName = "linux";
      moduleName = "nixosModules";
      inherit
        system
        ;
    };
  hmConfigForNixDarwinModules =
    system:
    hmConfigForModule {
      username = "taiki.watanabe";
      profileName = "macx64";
      moduleName = "darwinModules";
      inherit
        system
        ;
    };
}

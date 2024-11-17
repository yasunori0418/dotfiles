rec {
  args =
    {
      inputs,
      profileName,
      system,
    }:
    import ./default.nix {
      inherit profileName system;
      inherit (inputs)
        nixpkgs
        nixpkgs-stable
        neovim-nightly-overlay
        vim-overlay
        ;
    };
  hmConfigForNixosModule =
    { inputs, system }:
    let
      homeManagerConfig = args {
        profileName = "linux";
        inherit inputs system;
      };
    in
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        users.yasunori = {
          imports = homeManagerConfig.modules;
        };
        inherit (homeManagerConfig) extraSpecialArgs;
      };
    };
}

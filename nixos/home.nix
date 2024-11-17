{ inputs, system }:
{
  home-manager =
    let
      homeManagerConfig = import ../home-manager {
        profileName = "linux";
        inherit system;
        inherit (inputs)
          nixpkgs
          neovim-nightly-overlay
          vim-overlay
          ;
      };
    in
    {
      useGlobalPkgs = true;
      useUserPackages = true;
      users.yasunori = {
        imports = homeManagerConfig.modules;
      };
      inherit (homeManagerConfig) extraSpecialArgs;
    };
}

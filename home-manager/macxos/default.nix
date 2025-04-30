{
  pkgs,
  config,
  ...
}:
{
  imports =
    let
      dotfiles = /${config.home.homeDirectory}/dotfiles;
      homeDir = /${dotfiles}/home;
      xdgConfigHome = /${homeDir}/.config;
      packages = import ./packages.nix { inherit pkgs; };
      homeFile = import ./homeFile.nix {
        inherit
          pkgs
          config
          dotfiles
          homeDir
          xdgConfigHome
          ;
      };
      clearDppStateAfterLinkGeneration = ../clear-dpp-state-after-link-generation.nix;
    in
    [
      packages
      homeFile
      clearDppStateAfterLinkGeneration
    ];
  programs.home-manager.enable = true;
  home = {
    username = "taiki.watanabe";
    homeDirectory = "/Users/${config.home.username}";
    stateVersion = "24.05";
  };
}

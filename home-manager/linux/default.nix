{
  inputs,
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
      packages = ./packages.nix;
      homeFile = import ./homeFile.nix {
        inherit
          inputs
          pkgs
          config
          dotfiles
          homeDir
          xdgConfigHome
          ;
      };
      clearDppStateAfterLinkGeneration = ../clear-dpp-state-after-link-generation.nix;
      initialDotfilesCloneAfterOnFilesChange = ../initial-dotfiles-clone-after-on-files-change.nix;
      xdg = ../settings/xdg.nix;
      nix = ../settings/nix.nix;
    in
    [
      packages
      homeFile
      clearDppStateAfterLinkGeneration
      initialDotfilesCloneAfterOnFilesChange
      xdg
      nix
    ];
  programs.home-manager.enable = true;
  home = {
    username = "yasunori";
    homeDirectory = "/home/${config.home.username}";
    stateVersion = "24.05";
  };
}

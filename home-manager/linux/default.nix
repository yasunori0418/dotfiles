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
      nput = import ./nput.nix {
        inherit
          inputs
          pkgs
          homeDir
          xdgConfigHome
          ;
      };
      clearDppStateAfterLinkGeneration = ../clear-dpp-state-after-link-generation.nix;
      programs = [
        ../options/programs/nix-index.nix
      ];
      xdg = ../options/xdg.nix;
      nix = ../options/nix.nix;
    in
    [
      packages
      nput
      clearDppStateAfterLinkGeneration
      xdg
      nix
    ]
    ++ programs;
  programs.home-manager.enable = true;
  home = {
    username = "yasunori";
    homeDirectory = "/home/${config.home.username}";
    stateVersion = "24.05";
    extraOutputsToInstall = [
      "doc"
      "info"
      "devdoc"
    ];
  };
}

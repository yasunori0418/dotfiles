{
  inputs,
  pkgs,
  config,
  ...
}:
{
  imports =
    let
      packages = ./packages.nix;
      nput = import ./nput.nix {
        inherit
          inputs
          pkgs
          ;
        inherit (config.home) homeDirectory;
      };
      clearDppStateAfterLinkGeneration = ../clear-dpp-state-after-link-generation.nix;
      programs = [
        ../options/programs/nix-index.nix
        ../options/programs/discord.nix
      ];
      xdg = ../options/xdg.nix;
      nix = ../options/nix.nix;
      dconf = ../options/dconf.nix;
    in
    [
      packages
      nput
      clearDppStateAfterLinkGeneration
      xdg
      nix
      dconf
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

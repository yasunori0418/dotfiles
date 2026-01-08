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
      # programs = [
      #   ../options/programs/claude-code.nix
      # ];
      xdg = ../options/xdg.nix;
      nix = ../options/nix.nix;
    in
    [
      # inputs.claude-code-overlay.homeManagerModules.default
      packages
      homeFile
      clearDppStateAfterLinkGeneration
      xdg
      nix
    ]
    # ++ programs
    ;
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

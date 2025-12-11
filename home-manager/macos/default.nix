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
      launchd = [
        ../settings/launchd/clipcatd.nix
      ];
    in
    [
      packages
      homeFile
      clearDppStateAfterLinkGeneration
      initialDotfilesCloneAfterOnFilesChange
      inputs.mac-app-util.homeManagerModules.default
    ]
    ++ launchd;
  programs.home-manager.enable = true;
  home = {
    username = "taiki.watanabe";
    homeDirectory = "/Users/${config.home.username}";
    stateVersion = "24.05";
    extraOutputsToInstall = [
      "doc"
      "info"
      "devdoc"
    ];
  };
}

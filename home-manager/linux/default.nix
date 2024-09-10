{
  pkgs,
  config,
  wezterm-flake,
  flakeRoot,
  homeManager,
  ...
}:
rec {
  imports =
    let
      dotfiles = /${home.homeDirectory}/dotfiles;
      homeDir = /${dotfiles}/home;
      xdgConfigHome = /${dotfiles}/config;
      packages = import ./packages.nix {
        inherit
          pkgs
          wezterm-flake
          homeManager
          ;
      };
      fileMap = import /${homeManager}/fileMap.nix {
        inherit
          pkgs
          config
          flakeRoot
          dotfiles
          homeDir
          xdgConfigHome
          ;
      };
    in
    [
      packages
      fileMap
    ];
  programs.home-manager.enable = true;
  home = {
    username = "yasunori";
    homeDirectory = "/home/${home.username}";
    stateVersion = "24.05";
  };
}

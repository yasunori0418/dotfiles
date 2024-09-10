{
  pkgs,
  config,
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
      packages = import ./packages.nix { inherit pkgs homeManager; };
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
    username = "watanabe";
    homeDirectory = "/Users/${home.username}";
    stateVersion = "24.05";
  };
}

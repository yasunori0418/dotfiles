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
      packages = import /${homeManager}/pkgs.nix { inherit pkgs wezterm-flake; };
      fileMap = import /${homeManager}/fileMap.nix {
        inherit
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

{
  pkgs,
  config,
  wezterm-flake,
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
      homeFile = import ./homeFile.nix {
        inherit
          config
          homeManager
          dotfiles
          homeDir
          xdgConfigHome
          ;
      };
    in
    [
      packages
      homeFile
    ];
  programs.home-manager.enable = true;
  home = {
    username = "yasunori";
    homeDirectory = "/home/${home.username}";
    stateVersion = "24.05";
  };
}

{
  pkgs,
  pkgs-stable,
  claude-desktop,
  config,
  ...
}:
rec {
  imports =
    let
      dotfiles = /${home.homeDirectory}/dotfiles;
      homeDir = /${dotfiles}/home;
      xdgConfigHome = /${homeDir}/.config;
      packages = import ./packages.nix {
        inherit
          pkgs
          pkgs-stable
          claude-desktop
          ;
      };
      homeFile = import ./homeFile.nix {
        inherit
          pkgs
          config
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

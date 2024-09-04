{
  pkgs,
  config,
  wezterm-flake,
  flakeRoot,
  ...
}:
rec {
  imports =
    let
      dotfiles = /${home.homeDirectory}/dotfiles;
      homeDir = /${dotfiles}/home;
      xdgConfigHome = /${dotfiles}/config;
      packages = import ./pkgs.nix { inherit pkgs wezterm-flake; };
      fileMap = import ./fileMap.nix {
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
    username = "watanabe";
    homeDirectory = "/Users/${home.username}";
    stateVersion = "24.05";
  };
}
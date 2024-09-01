{
  pkgs,
  config,
  wezterm-flake,
  flakeRoot,
  homeManager,
  xdgConfigHome,
  homeDir,
  ...
}:
let
  packages = import /${homeManager}/pkgs.nix { inherit pkgs wezterm-flake; };
  fileMap = import /${homeManager}/fileMap.nix { inherit config flakeRoot homeDir xdgConfigHome; };
in
{
  imports = [
    packages
    fileMap
  ];
  programs.home-manager.enable = true;
  home = rec {
    username = "yasunori";
    homeDirectory = "/home/${username}";
    stateVersion = "24.05";
  };
}

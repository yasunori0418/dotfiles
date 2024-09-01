{
  pkgs,
  wezterm-flake,
  flakeRoot,
  homeManager,
  xdgConfigHome,
  homeDir,
  ...
}:
let
  packages = import /${flakeRoot}/home-manager/pkgs.nix { inherit pkgs wezterm-flake; };
in
{
  imports = [ packages ];
  programs.home-manager.enable = true;
  home = rec {
    username = "yasunori";
    homeDirectory = "/home/${username}";
    stateVersion = "24.05";
  };
}

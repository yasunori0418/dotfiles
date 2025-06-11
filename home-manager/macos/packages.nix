{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  home.packages =
    let
      applications = import ../applications.nix { inherit pkgs inputs lib; };
      packages =
        with applications;
        nixTools
        ++ utilityTools
        ++ terminalEmulators
        ++ textEditors
        ++ shellTools
        ++ languageServers
        ++ aiTools
        ++ codingSupportTools
        ++ libraries;
    in
    packages;
}

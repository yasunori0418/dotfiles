{
  inputs,
  pkgs,
  lib,
  nodePkgsBuilder,
  ...
}:
{
  home.packages =
    let
      nodePkgs = nodePkgsBuilder pkgs;
      applications = import ../applications.nix {
        inherit
          pkgs
          inputs
          lib
          nodePkgs
          ;
      };
      packages =
        with applications;
        nixTools
        ++ aiTools
        ++ codingSupportTools
        ++ languageServers
        ++ libraries
        ++ shellTools
        ++ terminalEmulators
        ++ textEditors
        ++ utilityTools;
    in
    packages;
}

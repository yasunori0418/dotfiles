{
  inputs,
  pkgs,
  lib,
  nodePkgsBuilder,
  ...
}:
{
  home =
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
    {
      inherit packages;
    };
}

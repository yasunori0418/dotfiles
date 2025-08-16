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
        ++ (textEditors ++ [ pkgs.emacs ])
        ++ shellTools
        ++ languageServers
        ++ codingSupportTools
        ++ libraries
        ++ utilityTools
        ++ (
          terminalEmulators
          ++ [
            pkgs.ghostty
          ]
        )
        ++ aiTools;
    in
    {
      inherit packages;
    };
}

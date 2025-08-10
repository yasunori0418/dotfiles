{
  inputs,
  pkgs,
  lib,
  # claude-desktop,
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
      # ++ [
      #   claude-desktop.packages.${pkgs.system}.claude-desktop
      # ];
    in
    {
      inherit packages;
    };
}

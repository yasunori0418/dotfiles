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
      concatTargetAttrsValue = import ../lib/concat-target-attrs-value.nix pkgs;
      applications = import ../applications.nix {
        inherit
          pkgs
          inputs
          lib
          nodePkgs
          ;
      };
      packages =
        (
          applications
          |> concatTargetAttrsValue [
            "nixTools"
            "aiTools"
            "codingSupportTools"
            "languageServers"
            "libraries"
            "shellTools"
            "terminalEmulators"
            "textEditors"
            "utilityTools"
          ]
        )
        ++ (
          applications.linuxDesktop
          |> concatTargetAttrsValue [
            "theme"
            "desktopApps"
            "i3wmTools"
          ]
        );
    in
    {
      inherit packages;
    };
}

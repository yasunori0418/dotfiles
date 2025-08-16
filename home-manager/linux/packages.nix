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
      mergeAttrsValue = import ../lib/merge-attrs-value.nix pkgs;
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
          |> mergeAttrsValue [
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
          |> mergeAttrsValue [
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

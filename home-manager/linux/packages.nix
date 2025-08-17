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
      inherit (import ../lib pkgs) concatTargetAttrsValue;
      applications = import ../applications.nix {
        inherit
          pkgs
          inputs
          lib
          nodePkgs
          ;
      };

      commonTools =
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
        ];

      linuxDesktopTools =
        applications.linuxDesktop
        |> concatTargetAttrsValue [
          "theme"
          "desktopApps"
          "i3wmTools"
        ];

      packages = commonTools ++ linuxDesktopTools;
    in
    {
      inherit packages;
    };
}

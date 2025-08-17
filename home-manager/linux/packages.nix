{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  home =
    let
      inherit (import ../lib pkgs) concatTargetAttrsValue;
      applications = import ../applications.nix {
        inherit
          pkgs
          inputs
          lib
          ;
      };

      commonTools =
        applications
        |> concatTargetAttrsValue [
          "aiTools"
          "codingSupportTools"
          "guiTools"
          "languageServers"
          "libraries"
          "nixTools"
          "shellTools"
          "terminalEmulators"
          "textEditors"
          "utilityTools"
        ];

      linuxDesktopTools =
        applications.linuxDesktop
        |> concatTargetAttrsValue [
          "desktopApps"
          "i3wmTools"
          "theme"
        ];

      packages = commonTools ++ linuxDesktopTools;
    in
    {
      inherit packages;
    };
}

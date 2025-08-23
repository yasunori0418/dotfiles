{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  home =
    let
      inherit (import ../lib pkgs) targetAttrsValue concatOfList;
      applications = import ../applications.nix {
        inherit
          pkgs
          inputs
          lib
          ;
      };

      commonTools =
        applications
        |> targetAttrsValue [
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
        ]
        |> concatOfList;

      linuxDesktopTools =
        applications.linuxDesktop
        |> targetAttrsValue [
          "desktopApps"
          "i3wmTools"
          "theme"
        ]
        |> concatOfList;

      packages = commonTools ++ linuxDesktopTools;
    in
    {
      inherit packages;
    };
}

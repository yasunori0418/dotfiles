{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  home =
    let
      inherit (pkgs.lib) pipe;
      inherit (inputs.yasunori-nur.legacyPackages.${pkgs.system}.lib.attrsets)
        targetAttrsValue
        concatOfList
        ;
      applications = import ../applications.nix {
        inherit
          pkgs
          inputs
          lib
          ;
      };

      commonTools = pipe applications [
        (targetAttrsValue [
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
        ])
        concatOfList
      ];

      linuxDesktopTools = pipe applications.linuxDesktop [
        (targetAttrsValue [
          "desktopApps"
          "i3wmTools"
          "theme"
        ])
        concatOfList
      ];

      packages = commonTools ++ linuxDesktopTools;
    in
    {
      inherit packages;
    };
}

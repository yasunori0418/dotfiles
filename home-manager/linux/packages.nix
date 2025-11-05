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
          # keep-sorted start
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
          # keep-sorted end
        ])
        concatOfList
      ];

      linuxDesktopTools = pipe applications.linuxDesktop [
        (targetAttrsValue [
          # keep-sorted start
          "desktopApps"
          "i3wmTools"
          "theme"
          # keep-sorted end
        ])
        concatOfList
      ];

      packages = commonTools ++ linuxDesktopTools;
    in
    {
      inherit packages;
    };
}

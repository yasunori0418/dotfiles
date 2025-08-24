{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  home.packages =
    let
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
      packages =
        applications
        |> targetAttrsValue [
          "aiTools"
          "codingSupportTools"
          "guiTools"
          "languageServers"
          "libraries"
          "macOs"
          "nixTools"
          "shellTools"
          "terminalEmulators"
          "textEditors"
          "utilityTools"
        ]
        |> concatOfList;
    in
    packages;
}

{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  home.packages =
    let
      inherit (import ../lib pkgs) targetAttrsValue concatOfList;
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

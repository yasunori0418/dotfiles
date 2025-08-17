{
  inputs,
  pkgs,
  lib,
  nodePkgsBuilder,
  ...
}:
{
  home.packages =
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
      packages =
        applications
        |> concatTargetAttrsValue [
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
        ];
    in
    packages;
}

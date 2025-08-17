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
    in
    packages;
}

{
  inputs,
  pkgs,
  lib,
  ...
}:
{
  home.packages =
    let
      inherit (import ../lib pkgs) concatTargetAttrsValue;
      applications = import ../applications.nix {
        inherit
          pkgs
          inputs
          lib
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

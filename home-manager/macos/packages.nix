{
  inputs,
  pkgs,
  ...
}:
{
  home.packages =
    let
      applications = import ../applications.nix { inherit pkgs inputs; };
      packages =
        with applications;
        nixTools
        ++ utilityTools
        ++ terminalEmulators
        ++ textEditors
        ++ shellTools
        ++ languageServers
        ++ codingSupportTools
        ++ libraries
        ++ [
          pkgs.colima
        ];
    in
    packages;
}

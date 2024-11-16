{
  pkgs,
  ...
}:
{
  home.packages =
    let
      applications = import ../applications.nix { inherit pkgs; };
      packages =
        with applications;
        nixTools
        ++ utilityTools
        ++ terminalEmulators
        ++ textEditors
        ++ shellTools
        ++ languageServers
        ++ codingSupportTools
        ++ libraries;
    in
    packages;
}

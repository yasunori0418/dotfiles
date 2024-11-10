{
  pkgs,
  homeManager,
  ...
}:
{
  home.packages =
    let
      applications = import "${homeManager}/applications.nix" { inherit pkgs; };
      packages =
        with applications;
        nixTools
        ++ utilityTools
        ++ tmuxTools
        ++ terminalEmulators
        ++ textEditors
        ++ shellTools
        ++ languageServers
        ++ codingSupportTools
        ++ libraries;
    in
    packages;
}

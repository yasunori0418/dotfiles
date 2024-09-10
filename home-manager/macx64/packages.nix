{
  pkgs,
  homeManager,
  ...
}:
{
  home.packages =
    let
      applicationList = import /${homeManager}/applicationList.nix { inherit pkgs; };
      apps = with applicationList; {
        inherit
          nixTools
          utilityTools
          textEditors
          shellTools
          languageServers
          libraries
          ;
        terminalEmulators = terminalEmulators ++ [ pkgs.wezterm ];
      };
    in
    with apps;
    [ ]
    ++ nixTools
    ++ utilityTools
    ++ textEditors
    ++ terminalEmulators
    ++ shellTools
    ++ languageServers
    ++ libraries;
}

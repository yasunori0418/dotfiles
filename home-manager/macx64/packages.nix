{
  pkgs,
  homeManager,
  ...
}:
{
  home.packages =
    let
      applications = import /${homeManager}/applications.nix { inherit pkgs; };
      applicationsOverride = with applications; {
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
    with applicationsOverride;
    [ ]
    ++ nixTools
    ++ utilityTools
    ++ textEditors
    ++ terminalEmulators
    ++ shellTools
    ++ languageServers
    ++ libraries;
}

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
          terminalEmulators
          textEditors
          shellTools
          languageServers
          codingSupportTools
          libraries
          ;
        # terminalEmulators = terminalEmulators ++ [ pkgs.wezterm ]; ## intel macを使っているのが悪い intel macを使っているのが悪い
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

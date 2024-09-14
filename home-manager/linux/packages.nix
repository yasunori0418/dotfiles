{
  pkgs,
  wezterm-flake,
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
          textEditors
          shellTools
          languageServers
          codingSupportTools
          libraries
          ;
        utilityTools = utilityTools ++ [ pkgs.deno ];
        terminalEmulators = terminalEmulators ++ [ wezterm-flake.packages.${pkgs.system}.default ];
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
    ++ codingSupportTools
    ++ libraries;
}

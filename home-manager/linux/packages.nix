{
  pkgs,
  wezterm-flake,
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
          textEditors
          shellTools
          languageServers
          libraries
          ;
        utilityTools = utilityTools ++ [ pkgs.deno ];
        terminalEmulators = terminalEmulators ++ [ wezterm-flake.packages.${pkgs.system}.default ];
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

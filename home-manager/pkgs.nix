{
  pkgs,
  lib,
  wezterm-flake,
  ...
}:
{
  home.packages =
    let
      applicationList = import ./applicationList.nix { inherit pkgs lib wezterm-flake; };
    in
    with applicationList;
    [ ]
    ++ nixTools
    ++ utilityTools
    ++ textEditors
    ++ terminalEmulators
    ++ shellTools
    ++ languageServers
    ++ libraries;
}

{
  inputs,
  pkgs,
  claude-desktop,
  ...
}:
{
  home.packages =
    let
      applications = import ../applications.nix { inherit pkgs inputs; };
      packages =
        with applications;
        nixTools
        ++ (textEditors ++ [ pkgs.emacs ])
        ++ shellTools
        ++ languageServers
        ++ codingSupportTools
        ++ libraries
        ++ utilityTools
        ++ (
          terminalEmulators
          ++ [
            pkgs.ghostty
          ]
        )
        ++ (
          aiTools
          ++ [
            claude-desktop.packages.${pkgs.system}.claude-desktop
          ]
        )
      # ++ clojureTools
      ;
    in
    packages;
}

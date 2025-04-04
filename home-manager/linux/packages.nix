{
  pkgs,
  pkgs-stable,
  ...
}:
{
  home.packages =
    let
      applications = import ../applications.nix { inherit pkgs; };
      packages =
        with applications;
        nixTools
        ++ textEditors
        ++ shellTools
        ++ languageServers
        ++ codingSupportTools
        ++ libraries
        ++ utilityTools
        ++ (
          terminalEmulators
          ++ [
            pkgs-stable.wezterm
            pkgs.ghostty
          ]
        )
      # ++ clojureTools
      ;
    in
    packages;
}

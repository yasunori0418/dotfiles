{
  pkgs,
  pkgs-stable,
  claude-desktop,
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
        ++ [
          claude-desktop.packages.${pkgs.system}.claude-desktop-with-fhs
        ]
      # ++ clojureTools
      ;
    in
    packages;
}

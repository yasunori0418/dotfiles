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
        ++ (
          utilityTools
          ++ [
            pkgs.deno
            pkgs.leetcode-cli
          ]
        )
        ++ (terminalEmulators ++ [ pkgs-stable.wezterm ])
        # ++ clojureTools
        ;
    in
    packages;
}

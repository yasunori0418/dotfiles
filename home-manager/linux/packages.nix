{
  pkgs,
  homeManager,
  ...
}:
{
  home.packages =
    let
      applications = import "${homeManager}/applications.nix" { inherit pkgs; };
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
        ++ terminalEmulators
        ++ clojureTools;
    in
    packages;
}

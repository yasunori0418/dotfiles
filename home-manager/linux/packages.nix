{
  pkgs,
  # wezterm-flake,
  homeManager,
  ...
}:
{
  home.packages =
    let
      applications = import /${homeManager}/applications.nix { inherit pkgs; };
      packages =
        with applications;
        nixTools
        ++ textEditors
        ++ shellTools
        ++ languageServers
        ++ codingSupportTools
        ++ libraries
        ++ (utilityTools ++ [ pkgs.deno ])
        ++ (terminalEmulators ++ [ /* wezterm-flake.packages.${pkgs.system}.default */ pkgs.wezterm ]);
    in
    with pkgs;
    [
      python312Full
      python312Packages.uv
      pdm
      leetcode-cli
    ]
    ++ packages;
}

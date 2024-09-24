{
  pkgs,
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
        ++ utilityTools
        ++ terminalEmulators
        # ++ (terminalEmulators ++ [ pkgs.wezterm ]) intel macを使っているのが悪い intel macを使っているのが悪い
        # weztermは社会性(homebrew)でインストールしている奴を使っている
        ++ textEditors
        ++ shellTools
        ++ languageServers
        ++ codingSupportTools
        ++ libraries;
    in
    with pkgs;
    [
      python312Packages.uv
      pdm
    ]
    ++ packages;
}

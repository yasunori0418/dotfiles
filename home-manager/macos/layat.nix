{
  inputs,
  pkgs,
  homeDirectory,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) system;

  # entries の組み立ては flake-parts の layat profile と共有する
  # （../layatEntries.nix・同じ entries から HM activation 用 manifest と
  # flake output `layat.<system>.default` が生成される）。
  entries = import ../layatEntries.nix {
    inherit inputs pkgs homeDirectory;
    isDarwin = true;
  };
in
{
  layat = {
    enable = true;
    inherit entries;
  };
  home.packages = [ inputs.layat.packages.${system}.layat ];
}

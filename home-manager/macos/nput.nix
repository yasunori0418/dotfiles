{
  inputs,
  pkgs,
  homeDirectory,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) system;

  # entries の組み立ては flake-parts の nput profile と共有する
  # （../nputEntries.nix・同じ entries から HM activation 用 manifest と
  # flake output `nput.<system>.default` が生成される）。
  entries = import ../nputEntries.nix {
    inherit inputs pkgs homeDirectory;
    isDarwin = true;
  };
in
{
  nput = {
    enable = true;
    inherit entries;
  };
  home.packages = [ inputs.nput.packages.${system}.nput ];
}

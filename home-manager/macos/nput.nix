{
  inputs,
  config,
  pkgs,
  dotfiles,
  homeDir,
  xdgConfigHome,
  ...
}:
{
  nput = {
    enable = true;
  };
  home.packages =
    let
      inherit (pkgs.stdenv.hostPlatform) system;
    in
    [ inputs.nput.packages.${system}.nput ];
}

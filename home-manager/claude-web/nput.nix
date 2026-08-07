{
  inputs,
  pkgs,
  homeDirectory,
  dotfilesDir,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) system;

  # entries の組み立ては linux / macos・flake-parts の nput profile と共有する
  # （../nputEntries.nix）。claude-web 固有の差は引数 2 つで表現する。
  #
  #   - dotfilesDir: clone 先が homeDirectory（/root）の配下ではない
  #   - commonTargets: nvim を使わないので dotLocalShare（treesitter parser）を取らない
  entries = import ../nputEntries.nix {
    inherit
      inputs
      pkgs
      homeDirectory
      dotfilesDir
      ;
    isDarwin = false;
    commonTargets = [
      "homeDirectory"
      "dotConfig"
    ];
  };
in
{
  nput = {
    enable = true;
    inherit entries;
    # image が /root/.bashrc・/root/.zshrc を持っており、そのままだと nput が
    # conflict で 1 件も配置せず止まる。既存を退避して置き換える。
    backup = {
      enable = true;
      suffix = "claude_web_backup";
    };
  };
  home.packages = [ inputs.nput.packages.${system}.nput ];
}

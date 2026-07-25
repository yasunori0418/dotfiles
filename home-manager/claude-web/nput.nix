{
  inputs,
  pkgs,
  homeDir,
  xdgConfigHome,
  ...
}:
let
  inherit (pkgs.lib) pipe;
  inherit (pkgs.stdenv.hostPlatform) system;
  myNurPkgs = inputs.yasunori-nur.legacyPackages.${system};
  inherit (myNurPkgs.lib.attrsets)
    targetAttrsValue
    concatOfAttrs
    ;
  inherit (inputs.nput.lib) mkOutOfStoreSymlink;

  # nput の src（out-of-store marker）には絶対パス文字列を渡す。homeDir / xdgConfigHome は
  # nix path 値なので toString で文字列化する（"${path}" 補間と違い store へコピーされない）。
  nputFileMap = import ../nputFileMap.nix {
    inherit
      inputs
      pkgs
      mkOutOfStoreSymlink
      ;
    homeDir = toString homeDir;
    xdgConfigHome = toString xdgConfigHome;
  };

  concatFileMap =
    targetNames: fileMap:
    pipe fileMap [
      (targetAttrsValue targetNames)
      concatOfAttrs
    ];

  # nvim を使わないセッションでは treesitter parser が要らないので dotLocalShare は取らない。
  entries =
    (concatFileMap [
      "homeDirectory"
      "dotConfig"
    ] nputFileMap)
    // (concatFileMap [
      "homeDirectory"
      "dotConfig"
    ] nputFileMap.Linux);
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

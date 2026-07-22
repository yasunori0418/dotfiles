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

  entries =
    (concatFileMap [
      "homeDirectory"
      "dotConfig"
      "dotLocalShare"
    ] nputFileMap)
    // (concatFileMap [
      "homeDirectory"
      "dotConfig"
      "library"
    ] nputFileMap.MacOS);
in
{
  nput = {
    enable = true;
    inherit entries;
  };
  home.packages = [ inputs.nput.packages.${system}.nput ];
}

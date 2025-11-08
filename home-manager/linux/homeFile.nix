{
  inputs,
  pkgs,
  config,
  dotfiles,
  homeDir,
  xdgConfigHome,
  ...
}:
let
  inherit (pkgs.lib) pipe;
  myNurPkgs = inputs.yasunori-nur.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  inherit (myNurPkgs.lib.attrsets)
    targetAttrsValue
    concatOfAttrs
    ;
  fileMap = import ../fileMap.nix {
    inherit
      pkgs
      myNurPkgs
      config
      dotfiles
      homeDir
      xdgConfigHome
      ;
  };
  concatFileMap =
    targetNames: fileMap:
    pipe fileMap [
      (targetAttrsValue targetNames)
      concatOfAttrs
    ];
  file =
    (concatFileMap [
      "homeDirectory"
      "dotConfig"
      "dotLocalShare"
    ] fileMap)
    // (concatFileMap [
      "homeDirectory"
      "dotConfig"
    ] fileMap.Linux);
in
{
  home = {
    inherit file;
  };
}

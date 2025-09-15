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
  myNurPkgs = inputs.yasunori-nur.legacyPackages.${pkgs.system};
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
      "dotConfig"
      "library"
    ] fileMap.MacOS);
in
{
  home = {
    inherit file;
  };
}

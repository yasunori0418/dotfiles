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
    fileMap |> targetAttrsValue targetNames |> concatOfAttrs;
  file =
    (
      fileMap
      |> concatFileMap [
        "homeDirectory"
        "dotConfig"
        "dotLocalShare"
      ]
    )
    // (
      fileMap.Linux
      |> concatFileMap [
        "homeDirectory"
        "dotConfig"
      ]
    );
in
{
  home = {
    inherit file;
  };
}

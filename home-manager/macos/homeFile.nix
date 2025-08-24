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
  inherit (inputs.yasunori-nur.legacyPackages.${pkgs.system}.lib.attrsets)
    targetAttrsValue
    concatOfAttrs
    ;
  fileMap = import ../fileMap.nix {
    inherit
      pkgs
      config
      dotfiles
      homeDir
      xdgConfigHome
      ;
  };
  concatFileMap =
    fileMap:
    let
      targetNames = [
        "homeDirectory"
        "dotConfig"
      ];
    in
    fileMap |> targetAttrsValue targetNames |> concatOfAttrs;
  file = (fileMap |> concatFileMap) // (fileMap.MacOS |> concatFileMap);
in
{
  home = {
    inherit file;
  };
}

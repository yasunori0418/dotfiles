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
  concatFileMap = targetNames: fileMap: fileMap |> targetAttrsValue targetNames |> concatOfAttrs;
  file =
    (
      fileMap
      |> concatFileMap [
        "homeDirectory"
        "dotConfig"
      ]
    )
    // (
      fileMap.MacOS
      |> concatFileMap [
        "dotConfig"
        "library"
      ]
    );
in
{
  home = {
    inherit file;
  };
}

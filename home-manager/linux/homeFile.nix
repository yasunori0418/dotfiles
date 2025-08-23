{
  pkgs,
  config,
  dotfiles,
  homeDir,
  xdgConfigHome,
  ...
}:
let
  inherit (import ../lib pkgs) targetAttrsValue concatOfAttrs;
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
  file = (fileMap |> concatFileMap) // (fileMap.Linux |> concatFileMap);
in
{
  home = {
    inherit file;
  };
}

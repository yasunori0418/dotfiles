{
  config,
  dotfiles,
  homeDir,
  xdgConfigHome,
  ...
}:
let
  fileMap = import ../fileMap.nix {
    inherit
      config
      dotfiles
      homeDir
      xdgConfigHome
      ;
  };
  file =
    with fileMap;
    homeDirectory // dotConfig // MacOS.homeDirectory // MacOS.library // MacOS.dotConfig;
in
{
  home = {
    inherit file;
  };
}

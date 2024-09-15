{
  config,
  homeManager,
  dotfiles,
  homeDir,
  xdgConfigHome,
  ...
}:
let
  fileMap = import /${homeManager}/fileMap.nix {
    inherit
      config
      dotfiles
      homeDir
      xdgConfigHome
      ;
  };
  file =
    with fileMap;
    { } // homeDirectory // dotConfig // MacOS.homeDirectory // MacOS.xdgConfigHome;
in
{
  home = {
    inherit file;
  };
}

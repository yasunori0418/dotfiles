{
  config,
  # flakeRoot,
  homeDir,
  # xdgConfigHome,
  ...
}:
{
  home.file = {
    ".docker" = {
      source = /${homeDir}/.docker;
      recursive = false;
    };
  };
}

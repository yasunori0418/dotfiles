{ pkgs, config, ... }:
{
  launchd.agents.clipcatd = {
    enable = true;
    config = {
      ProgramArguments = [
        "${pkgs.clipcat}/bin/clipcatd"
        "--no-daemon"
        "--replace"
        "--config"
        "${config.home.homeDirectory}/.config/clipcat/clipcatd.toml"
      ];
      RunAtLoad = true;
      KeepAlive = true;
    };
  };
}

{
  inputs,
  pkgs,
  config,
  ...
}:
let
  headroom = inputs.yasunori-nur.packages.${pkgs.stdenv.hostPlatform.system}.headroom;
in
{
  launchd.agents.headroomd = {
    enable = true;
    config = {
      ProgramArguments = [
        "${headroom}/bin/headroom"
        "proxy"
        "--host"
        "127.0.0.1"
        "--port"
        "8787"
      ];
      EnvironmentVariables = {
        # opt out: disable telemetry: https://headroom-docs.vercel.app/docs/community-savings
        # launchd daemon は shell の extra_env.zsh を継承しないため明示する
        HEADROOM_TELEMETRY = "off";
      };
      RunAtLoad = true;
      KeepAlive = true;
      StandardOutPath = "${config.home.homeDirectory}/Library/Logs/headroomd.out.log";
      StandardErrorPath = "${config.home.homeDirectory}/Library/Logs/headroomd.err.log";
    };
  };
}

{ inputs, pkgs, ... }:
let
  headroom = inputs.yasunori-nur.packages.${pkgs.stdenv.hostPlatform.system}.headroom;
in
{
  systemd.user.services.headroomd = {
    Unit = {
      Description = "Headroom optimization proxy (daemon)";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };

    Service = {
      Type = "simple";
      Environment = [
        # opt out: disable telemetry: https://headroom-docs.vercel.app/docs/community-savings
        # systemd user service は shell の extra_env.zsh を継承しないため明示する
        "HEADROOM_TELEMETRY=off"
      ];
      ExecStart = "${headroom}/bin/headroom proxy --host 127.0.0.1 --port 8787";
      Restart = "on-failure";
      RestartSec = 5;
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}

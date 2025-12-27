{ pkgs, ... }:
{
  systemd.user.services.clipcatd = {
    description = "clipcat daemon";
    enable = true;
    wantedBy = [ "graphical-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStartPre = "${pkgs.coreutils}/bin/rm -f %t/clipcat/grpc.sock";
      ExecStart = "${pkgs.clipcat}/bin/clipcatd --no-daemon --replace";
      Restart = "on-failure";
    };
  };
}

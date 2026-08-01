{ pkgs, ... }:
{
  systemd.user.services.clipcatd = {
    description = "clipcat daemon";
    enable = true;
    # graphical-session.target は nixos-fake-graphical-session.target 経由で
    # sway の起動完了前に発火するため、WAYLAND_DISPLAY を持たないまま起動して
    # クリップボードの初期化に失敗する（X11 backend へ fallback したうえで
    # "$DISPLAY variable not set" となる）。sway が import-environment 後に
    # 起動する sway-session.target へ紐付ける。
    # WAYLAND_DISPLAY さえ入っていれば clipcatd は Wayland backend を自動選択する。
    wantedBy = [ "sway-session.target" ];
    after = [ "sway-session.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStartPre = "${pkgs.coreutils}/bin/rm -f %t/clipcat/grpc.sock";
      ExecStart = "${pkgs.clipcat}/bin/clipcatd --no-daemon --replace";
      Restart = "on-failure";
    };
  };
}

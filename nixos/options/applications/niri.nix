{
  programs.niri = {
    enable = true;
  };

  # niri起動完了後にxdg-desktop-portal関連サービスを起動するよう設定
  # niriが環境変数(WAYLAND_DISPLAY等)をsystemdにimportした後に起動する
  systemd.user.services.xdg-desktop-portal-gtk = {
    after = [ "niri.service" ];
  };

  systemd.user.services.xdg-desktop-portal-wlr = {
    after = [ "niri.service" ];
  };

  systemd.user.services.xdg-desktop-portal-gnome = {
    after = [ "niri.service" ];
  };
}

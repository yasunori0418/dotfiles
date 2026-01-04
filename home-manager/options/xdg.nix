{ pkgs, ... }:
{
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
    };
    portal = {
      enable = true;
      xdgOpenUsePortal = true;
      config = {
        sway = {
          default = "gtk";
          "org.freedesktop.impl.portal.Inhibit" = "none";
          "org.freedesktop.impl.portal.ScreenCast" = "wlr";
          "org.freedesktop.impl.portal.Screenshot" = "wlr";
        };
        niri = {
          default = "gnome;gtk";
          "org.freedesktop.impl.portal.Access" = "gtk";
          "org.freedesktop.impl.portal.Notification" = "gtk";
          "org.freedesktop.impl.portal.Secret" = "gnome-keyring";
        };
      };
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-wlr
        xdg-desktop-portal-gnome
      ];
    };

    # niri起動完了後にxdg-desktop-portal関連サービスを起動するよう設定
    # niriが環境変数(WAYLAND_DISPLAY等)をsystemdにimportした後に起動する
    # systemd drop-inファイルで既存サービスの起動順序を変更
    configFile."systemd/user/xdg-desktop-portal-gtk.service.d/after-niri.conf".text = ''
      [Unit]
      After=niri.service
    '';

    configFile."systemd/user/xdg-desktop-portal-wlr.service.d/after-niri.conf".text = ''
      [Unit]
      After=niri.service
    '';

    configFile."systemd/user/xdg-desktop-portal-gnome.service.d/after-niri.conf".text = ''
      [Unit]
      After=niri.service
    '';
  };
}

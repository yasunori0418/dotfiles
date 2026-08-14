{
  # GTK3/4 は dconf に値があるとそちらを優先し、~/.config/gtk-3.0/settings.ini の
  # gtk-icon-theme-name を無視する。icon-theme に GTK テーマ名 Nordic-darker が
  # 入っていると、アイコンテーマとしては存在しないため hicolor へフォールバックし、
  # thunar 等のフォルダアイコンが Nordzy にならない。SSOT を dconf 側へ寄せる。
  dconf.settings."org/gnome/desktop/interface" = {
    icon-theme = "Nordzy";
    gtk-theme = "Nordic-darker";
    cursor-theme = "Nordzy-cursors";
  };
}

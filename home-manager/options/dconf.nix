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

  # showmethekey は設定ファイルを持たず GSettings のみに保存するため、
  # GUI で調整した値を宣言側へ寄せて再現可能にする。
  # width/height/alignment/margin-ratio/timeout はスキーマ既定
  # (1500/200/"end"/0.4/0) と異なる調整済みの値。
  dconf.settings."one/alynx/showmethekey" = {
    clickable = true;
    clickable-modifier = "ctrl";
    paused = false;
    paused-modifier = "alt";
    show-shift = true;
    show-keyboard = true;
    show-mouse = true;
    draw-border = true;
    hide-visible = false;
    mode = "composed";
    alignment = "center";
    timeout = 800.0;
    width = 500.0;
    height = 100.0;
    margin-ratio = 0.38;
    layout = "us";
    variant = "";
  };
}

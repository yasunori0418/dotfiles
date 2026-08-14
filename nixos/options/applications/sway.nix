{ pkgs, ... }:
{
  programs.sway = {
    enable = true;
    extraOptions = [
      "--verbose"
      "--debug"
      "--unsupported-gpu"
    ];
    # swaybar の SNI トレイは gdk-pixbuf でアイコンを読む。librsvg の
    # loaders.cache を渡さないと SVG ローダが登録されず、blueman-applet 等の
    # SVG トレイアイコンが「Couldn't recognize the image file format」で
    # 読み込み失敗し、fallback の壊れたアイコンが表示される。
    extraSessionCommands = ''
      export GDK_PIXBUF_MODULE_FILE="${pkgs.librsvg}/lib/gdk-pixbuf-2.0/2.10.0/loaders.cache"
    '';
  };
}

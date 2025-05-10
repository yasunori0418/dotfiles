{ pkgs, ... }:
{
  # フォントの設定
  fonts = {
    packages = with pkgs; [
      hackgen-nf-font
    ];
  };
}

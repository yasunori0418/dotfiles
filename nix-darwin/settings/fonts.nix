{ pkgs, ... }:
{
  # フォントの設定
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-serif
      noto-fonts-cjk-sans
      # noto-fonts-color-emoji
      nerd-fonts.hack
      hackgen-nf-font
      font-awesome_6
      moralerspace-hw
    ];
  };
}

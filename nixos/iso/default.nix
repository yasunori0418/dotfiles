{
  pkgs,
  ...
}:
{
  imports = [
    (import ../settings/networking.nix {
      hostName = "iso";
      wifi-power-save = true;
    })
    ../settings/time.nix
    ../settings/i18n.nix
  ];
  environment = {
    systemPackages = with pkgs; [
      git
      vim
      gnumake
    ];
  };
  nix.settings.experimental-features = [
    "flakes"
    "nix-command"
    "pipe-operators"
  ];
  system.installer.channel.enable = false;
  programs = {
    sway = {
      enable = true;
      extraOptions = [
        "--verbose"
        "--debug"
        "--unsupported-gpu"
      ];
    };
    foot = {
      enable = true;
      theme = "nord";
      settings.main.font = "Moralerspace Argon HW:size=14";
    };
  };
  security.polkit.enable = true;
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-serif
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      nerd-fonts.hack
      hackgen-nf-font
      moralerspace-hw
    ];
    fontDir.enable = true;
    fontconfig = {
      defaultFonts = {
        serif = [ "Noto Serif CJK JP" ];
        sansSerif = [ "Noto Sans CJK JP" ];
        monospace = [ "Noto Sans Mono CJK JP" ];
        emoji = [ "Moralerspace Argon HW" "Noto Color Emoji" ];
      };
    };
  };
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];
    wlr.enable = true;
  };
}

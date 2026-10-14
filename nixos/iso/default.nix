{
  pkgs,
  modulesPath,
  ...
}:
{

  imports = [
    (import ../options/networking.nix {
      hostName = "iso";
      wifi-power-save = true;
    })
    ../options/nix.nix
    ../options/nixpkgs.nix
    ../options/fonts.nix
    ../options/time.nix
    ../options/i18n.nix
    ../options/services/resolved.nix
  ];

  # `nixos-rebuild build-image --image-variant iso-installer --flake .#iso` で生成する。
  # installer 固有の設定は toplevel に置かず、ISO イメージ用のモジュール内に閉じ込める。
  image.modules.iso-installer = {
    imports = [ "${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix" ];
    system.installer.channel.enable = false;
    # インストールメディアのときにデフォルトで有効になるisoImageの定義を明示
    isoImage = {
      makeBiosBootable = true;
      makeEfiBootable = true;
      makeUsbBootable = true;
    };
  };

  # 以下は toplevel を評価可能にするためのダミー。
  # ISO 側は iso-image.nix が mkImageMediaOverride で同じ値を強制するため影響しない。
  fileSystems."/" = {
    device = "none";
    fsType = "tmpfs";
  };
  boot.loader.grub.enable = false;

  environment = {
    systemPackages = with pkgs; [
      git
      vim
      gnumake
    ];
  };
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
  # 起動後に ly が nixos ユーザーで自動ログインし、そのまま sway を立ち上げる
  services.displayManager = {
    ly.enable = true;
    defaultSession = "sway";
    autoLogin = {
      enable = true;
      user = "nixos";
    };
  };
  security.polkit.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];
    wlr.enable = true;
  };
}

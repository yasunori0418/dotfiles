/*
  Claude Code on the web（claude-web）セッション向けのスタンドアロン Home Manager
  プロファイル。

  linux / macos プロファイルとの違い:
    - コンテナは毎セッション作り直され、repo は `~/dotfiles` ではなく
      `/home/user/dotfiles` に clone される。out-of-store symlink の起点はそちらへ向ける。
    - サンドボックスは root で動く。systemd は無い（→ nix は
      `nix-installer --init none` で入れ、daemon は setup script が起動する）。
    - 配置は linux と同じ nputFileMap から取るが、dotLocalShare（treesitter parser）は
      取らない（→ ./nput.nix）。
    - 入れるのは配置した設定・skill・hook が実際に exec するものだけ（→ ./packages.nix）。

  適用は `scripts/claude-web-setup.sh`（nix インストール → activationPackage
  ビルド → activate）。
*/
{ inputs, pkgs, ... }:
{
  imports =
    let
      # claude-web のセッションでは repo がこの位置に clone される。
      dotfiles = /home/user/dotfiles;
      homeDir = /${dotfiles}/home;
      xdgConfigHome = /${homeDir}/.config;
      packages = ./packages.nix;
      nput = import ./nput.nix {
        inherit
          inputs
          pkgs
          homeDir
          xdgConfigHome
          ;
      };
    in
    [
      packages
      nput
    ];

  # closure はそのまま毎セッションのダウンロード時間になるので、要らないものを外す。
  programs = {
    # 適用は scripts/claude-web-setup.sh が activationPackage を直接叩くので CLI は不要。
    home-manager.enable = false;
    # 共通で読み込む nix-index-database の HM モジュールが引くフル DB を止める。
    nix-index.enable = false;
  };
  manual.manpages.enable = false;
  # 非 NixOS では LOCALE_ARCHIVE 用に glibcLocales（全ロケール・200MB 超）が入る。
  i18n.glibcLocales = pkgs.glibcLocalesUtf8;

  home = {
    # claude-web のサンドボックスは root / HOME=/root で動く。
    username = "root";
    homeDirectory = "/root";
    stateVersion = "24.05";
  };
}

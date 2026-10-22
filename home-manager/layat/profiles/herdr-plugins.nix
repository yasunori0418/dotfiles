# profile `herdr-plugins`: ~/.local/share/herdr-plugins/*（herdr-plugin-link の対象）。
{
  pkgs,
  inputs,
  ...
}:
{
  /*
    herdr プラグイン本体。derivation の $out がそのまま plugin_root になる
    （$out 直下に herdr-plugin.toml が居る形へ各 package 側で整形済み）。

    配置しただけでは herdr は認識しない。herdr はプラグインをディレクトリ
    走査で発見せず ~/.config/herdr/plugins.json への登録を見るため、配置後に
    `herdr plugin link <dir>` が要る（scripts/herdr-plugin-link.sh が担い、
    switch 時の activation と `make herdr-plugin-link` の両方から呼ぶ）。

    link は渡されたパスを canonicalize して実体（= store パス）を記録するので、
    plugins.json には /nix/store/... が入る。プラグインを更新すると store パスが
    変わり登録が stale になるため、link は switch のたびに再実行する
    （同一 plugin_id は上書きされる冪等操作）。
  */
  subdir = ".local/share/herdr-plugins";
  common = {
    "worktrunk".src = pkgs.callPackage ../../packages/herdr-worktrunk.nix {
      src = inputs.herdr-worktrunk;
    };
    "navigator".src = pkgs.callPackage ../../packages/herdr-navigator.nix {
      src = inputs.herdr-navigator;
    };
    "plus".src = pkgs.callPackage ../../packages/herdr-plus.nix {
      src = inputs.herdr-plus;
    };
  };
  MacOS = { };
  Linux = { };
}

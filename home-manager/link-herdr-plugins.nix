# switch のたびに herdr プラグインをレジストリへ登録し直す activation。
#
# nput が ~/.local/share/herdr-plugins/* へ配置しても herdr は認識しない
# （herdr はディレクトリ走査ではなく ~/.config/herdr/plugins.json への登録を見る）。
# さらに link は実体（= store パス）を記録するため、プラグイン更新で store パスが
# 変わるたび登録が stale になる。よって配置後に毎回 link を流す。
#
# 処理の実体は scripts/herdr-plugin-link.sh で、`make herdr-plugin-link` と共有する。
# activation からは store へコピーしたものを実行する（~/dotfiles の実体を直接
# 指すと、リポジトリを移動・改名した瞬間に switch が壊れるため）。
{
  lib,
  pkgs,
  ...
}:
let
  # スクリプトは shebang と set -euo pipefail を自前で持つので、
  # writeShellApplication で包み直さず store へそのままコピーして実行する
  # （Makefile から叩くものと完全に同一の内容を走らせる）。
  linkHerdrPlugins = pkgs.runCommandLocal "herdr-plugin-link" { } ''
    install -Dm555 ${../scripts/herdr-plugin-link.sh} $out/bin/herdr-plugin-link
  '';
in
{
  # nput の配置（home.activation.nput）が終わってからでないと
  # ~/.local/share/herdr-plugins/* がまだ無い、あるいは古い世代を指しているため
  # entryAfter は writeBoundary/linkGeneration ではなく nput を指定する。
  home.activation.linkHerdrPlugins = lib.hm.dag.entryAfter [ "nput" ] ''
    run ${linkHerdrPlugins}/bin/herdr-plugin-link
  '';
}

# switch のたびに ~/.claude/settings.json へ環境固有の値を注入し直す
# activation（macOS 限定）。
#
# settings.json は claudeSettings.nix から生成した JSON を nput が配置するが、
# その環境にしか存在しない値は Nix 側に置けない。そうした値は
# ~/.claude/inject/*.json に置き、配置後の settings.json へ後から重ねる。
# 何を注入するかはリポジトリ側の関心事ではないため、ここには持たない。
#
# settings.json は nput の method = "copy"（place-once）で配置される。
# `nput apply --recopy` すると Nix 生成の JSON に戻って注入分が消えるため、
# recopy 後は make nput-recopy が続けて同じスクリプトを流す（Makefile 側）。
#
# 処理の実体は scripts/claude-settings-inject.sh で、`make claude-settings-inject`
# と共有する。activation からは store へコピーしたものを実行する（~/dotfiles の
# 実体を直接指すと、リポジトリを移動・改名した瞬間に switch が壊れるため）。
{
  lib,
  pkgs,
  ...
}:
let
  # スクリプトは shebang と set -euo pipefail を自前で持つので、
  # writeShellApplication で包み直さず store へそのままコピーして実行する
  # （Makefile から叩くものと完全に同一の内容を走らせる）。
  injectClaudeSettings = pkgs.runCommandLocal "claude-settings-inject" { } ''
    install -Dm555 ${../scripts/claude-settings-inject.sh} $out/bin/claude-settings-inject
  '';
in
{
  # nput の配置（home.activation.nput）が終わって ~/.claude/settings.json が
  # 実体化した後でないと注入対象が無いため、entryAfter は nput を指定する。
  home.activation.injectClaudeSettings = lib.hm.dag.entryAfter [ "nput" ] ''
    run ${injectClaudeSettings}/bin/claude-settings-inject
  '';
}

# switch のたびに ~/.claude/settings.json へ環境固有の値を注入し直す
# activation（macOS 限定）。
#
# 注入する値はこの環境にしか存在しない設定を含むため、リポジトリでは値も
# 注入ロジックも管理せず ~/.claude/inject/ に置く。ここからはその実体の有無を
# 確かめて呼ぶだけで、実体が無いマシンでは何もしない（switch を壊さない）。
#
# ~/.claude/settings.json は nput の method = "copy"（place-once）で配置される。
# `nput apply --recopy` すると Nix 生成の JSON に戻って注入分が消えるため、
# 配置をやり直したあとは注入も流し直す必要がある。
{ lib, ... }:
{
  # nput の配置（home.activation.nput）が終わって ~/.claude/settings.json が
  # 実体化した後でないと注入対象が無いため、entryAfter は nput を指定する。
  home.activation.injectClaudeSettings = lib.hm.dag.entryAfter [ "nput" ] ''
    claude_inject="$HOME/.claude/inject/inject.sh"
    if [ -x "$claude_inject" ]; then
      run "$claude_inject"
    fi
  '';
}

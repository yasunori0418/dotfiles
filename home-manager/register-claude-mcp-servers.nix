# switch のたびに ~/.claude/mcp-servers.json の MCP サーバー定義を
# Claude Code の user スコープ（~/.claude.json）へ登録し直す activation。
#
# Claude Code は settings.json からサーバー定義を読まず、~/.claude.json は
# Claude Code 自身が書き込む状態ファイルなので layat では配置できない。
# よって layat が定義ファイルを配置した後に `claude mcp` で登録する。
#
# 処理の実体は scripts/claude-mcp-register.sh で、`make claude-mcp-register` と共有する。
# activation からは store へコピーしたものを実行する（~/dotfiles の実体を直接
# 指すと、リポジトリを移動・改名した瞬間に switch が壊れるため）。
{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  inherit (pkgs.stdenv.hostPlatform) system;

  # applications.nix が入れているものと同じ claude を使う。
  claude = inputs.nix-claude-code.packages.${system}.default;

  # スクリプトは shebang と set -euo pipefail を自前で持つので、
  # writeShellApplication で包み直さず store へそのままコピーして実行する
  # （Makefile から叩くものと完全に同一の内容を走らせる）。
  registerClaudeMcpServers = pkgs.runCommandLocal "claude-mcp-register" { } ''
    install -Dm555 ${../scripts/claude-mcp-register.sh} $out/bin/claude-mcp-register
  '';
in
{
  # layat の配置（home.activation.layat）が終わって ~/.claude/mcp-servers.json が
  # 新しい世代を指した後でないと古い定義を登録してしまうため、entryAfter は layat を指定する。
  #
  # NixOS の HM は activation を systemd service で走らせ、その PATH は
  # coreutils 等の最小構成に固定される（claude も jq も PATH から引けない）。
  # よって claude は CLAUDE_BIN で渡し、jq は PATH の先頭へ足す。
  home.activation.registerClaudeMcpServers = lib.hm.dag.entryAfter [ "layat" ] ''
    run env CLAUDE_BIN=${lib.getExe claude} PATH=${lib.makeBinPath [ pkgs.jq ]}:"$PATH" \
      ${registerClaudeMcpServers}/bin/claude-mcp-register
  '';
}

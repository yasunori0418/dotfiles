/*
  Claude Code の user スコープへ登録する MCP サーバー定義を JSON として生成する。

  Claude Code は settings.json からサーバー定義を読まない（settings.json の MCP 系キーは
  承認・許可ポリシーだけで、定義の置き場は ~/.claude.json / .mcp.json）。
  ~/.claude.json は Claude Code 自身が書き込む状態ファイルで layat では配置できないため、
  定義は ~/.claude/mcp-servers.json として配置し、scripts/claude-mcp-register.sh が
  `claude mcp add-json --scope user` で ~/.claude.json へ登録する。

  値は `claude mcp add-json` にそのまま渡す形（type / command / args）で書く。
  登録スクリプトはこの値と ~/.claude.json に保存された定義を比べて差分を判定する
  （add-json が保存時に補う空の既定値は比較から除く）。
*/
{
  pkgs,
  # textlint MCP サーバーに `--config` で渡す .textlintrc.json のパス。
  # "~/" 始まりで渡し、scripts/claude-mcp-register.sh が登録時に $HOME へ展開する。
  textlintConfig,
}:
let
  textlint = pkgs.callPackage ./packages/textlint.nix { };

  jsonFormat = pkgs.formats.json { };
in
jsonFormat.generate "claude-mcp-servers.json" {
  tirith = {
    type = "stdio";
    command = "tirith";
    args = [ "mcp-server" ];
  };
  # PATH に依存しないよう store の絶対パスで起動する。
  textlint = {
    type = "stdio";
    command = "${textlint}/bin/textlint";
    args = [
      "--mcp"
      "--config"
      textlintConfig
    ];
  };
}

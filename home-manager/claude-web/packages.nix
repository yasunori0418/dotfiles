/*
  claude-web セッションへ入れるツール。

  選定基準は「配置した settings.json / cchook config / skill / hook が実際に exec する
  binary」だけ。image に同名のものがあっても、開発環境の供給元を dotfiles へ寄せるため
  Nix 側から入れる。

  ここに足す前に、その設定・skill・hook が本当にそれを exec しているか確認すること。

  gh は入れない。claude-web の GH_TOKEN は policy proxy のプレースホルダで、
  `gh auth status` は invalid、repo スコープの REST（`repos/.../pulls` 等）と GraphQL
  （`gh pr view` / `gh pr checks`）はどちらも proxy が 403 を返す。github 系 skill の
  実行経路（`gh pr create` / `gh pr checks` / `gh run view` / `gh auth git-credential`）が
  丸ごと機能しないため、GitHub 操作は GitHub MCP に寄せる。
*/
{ inputs, pkgs, ... }:
let
  myNurPkgs = inputs.yasunori-nur.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  home.packages = [
    myNurPkgs.cchook # settings.json の全 hook event の受け口
  ]
  ++ (with pkgs; [
    # keep-sorted start
    gitMinimal # ほぼ全ての skill / hook の土台。perl/python 依存を落とした版で足りる
    jq # 全 hook が stdin の JSON を読むのに使う
    python312Packages.uv # cchook config が tirith-check.py を uv 経由で回す
    tirith # settings.json の mcpServers.tirith
    # keep-sorted end
  ]);
}

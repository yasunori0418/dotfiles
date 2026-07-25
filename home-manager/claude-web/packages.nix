/*
  claude-web セッションへ入れるツール。

  選定基準は「配置した settings.json / cchook config / skill / hook が実際に exec する
  binary」だけ。image に同名のものがあっても、開発環境の供給元を dotfiles へ寄せるため
  Nix 側から入れる。

  ここに足す前に、その設定・skill・hook が本当にそれを exec しているか確認すること。
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
    gh # github 系 skill・gh-push の push 経路
    gitMinimal # ほぼ全ての skill / hook の土台。perl/python 依存を落とした版で足りる
    jq # 全 hook が stdin の JSON を読むのに使う
    python312Packages.uv # cchook config が tirith-check.py を uv 経由で回す
    tirith # settings.json の mcpServers.tirith
    # keep-sorted end
  ]);
}

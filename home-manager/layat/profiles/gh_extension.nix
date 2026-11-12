# profile `gh_extension`: ~/.local/share/gh/extensions/*（gh CLI の拡張）。
# subdir = ".local/share/gh/extensions" なので entries のキーはそこからの相対で書く。
{
  pkgs,
  lib,
  ...
}:
let
  yamlFormat = pkgs.formats.yaml { };

  /*
    nixpkgs の gh 拡張パッケージ 1 つを、gh が「バイナリ拡張」として認識する形へ展開する。

    gh は extensions/gh-<name> が実ディレクトリで manifest.yml を持つときだけバイナリ拡張と
    みなし、`gh extension list` の REPO / VERSION を manifest から出す。gh-<name> 自体を
    store の bin への symlink にするとローカル拡張扱いになり manifest を読まないため、
    ディレクトリは実体のまま、実行ファイルと manifest.yml をファイル単位で配置する。

    manifest.yml は `gh extension install` が書くもので gh 単体では生成できない。
    同じ内容を package の src（fetchFromGitHub の owner / repo / tag）から組み立てる。
    tag を持たない package は rev を使う（tag 指定時の rev は refs/tags/... になるため tag を優先）。

    ispinned = true は `gh extension upgrade` に store への書き込みを試させないため
    （pinned な拡張は --force 無しでは upgrade されない）。更新は `nix flake update nixpkgs`。
    バイナリ拡張は実行時に更新チェックが走るので、通知は
    GH_NO_EXTENSION_UPDATE_NOTIFIER（home/.zsh/sync/extra_env.zsh）で止めている。

    前提: パッケージ名（pname）・実行ファイル名・リポジトリ名がすべて gh-<name> で一致すること。
  */
  ghExtension =
    package:
    let
      name = package.pname;
      inherit (package) src;
      tag = src.tag or null;
    in
    {
      "${name}/${name}" = {
        src = package;
        subpath = "bin/${name}";
      };
      "${name}/manifest.yml".src = yamlFormat.generate "${name}-manifest.yml" {
        inherit (src) owner;
        name = src.repo;
        host = "github.com";
        tag = if tag != null then tag else src.rev;
        ispinned = true;
      };
    };
in
{
  subdir = ".local/share/gh/extensions";
  common = lib.mergeAttrsList (
    map ghExtension [
      # keep-sorted start
      pkgs.gh-actions-lock
      pkgs.gh-stack
      # keep-sorted end
    ]
  );
  MacOS = { };
  Linux = { };
}

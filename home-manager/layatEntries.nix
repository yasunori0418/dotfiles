# layat の home mode（root = homeRoot）entries を組み立てる共有モジュール。
#
# home-manager モジュール（home-manager/{linux,macos}/layat.nix）と flake-parts の
# layat profile（flake-parts/layat.nix）の両方から import される。配置元は
# root 相対 marker で $HOME からの相対パスとして書くため、home ディレクトリの
# 絶対パスには依存しない。
#
# entries そのものは root 非依存（root は mkManifest / HM モジュールが homeRoot に
# pin する）ため、同じ entries から HM activation 用の manifest と CLI 用の
# flake output `layat.<system>.default` が同一内容で生成される。
{
  inputs,
  pkgs,
  isDarwin,
}:
let
  inherit (pkgs.lib) pipe;
  inherit (pkgs.stdenv.hostPlatform) system;
  myNurPkgs = inputs.yasunori-nur.legacyPackages.${system};
  inherit (myNurPkgs.lib.attrsets)
    targetAttrsValue
    concatOfAttrs
    ;
  inherit (inputs.layat.lib) mkRootRelativeSymlink;

  # layat の src（root 相対 marker）には配置 root（home mode なので $HOME）からの
  # 相対パスを渡す。engine が target の親を起点とする相対リンクを張る。
  dotfiles = "dotfiles";
  homeDir = "${dotfiles}/home";
  xdgConfigHome = "${homeDir}/.config";

  layatFileMap = import ./layatFileMap.nix {
    inherit
      inputs
      pkgs
      mkRootRelativeSymlink
      homeDir
      xdgConfigHome
      ;
  };

  concatFileMap =
    targetNames: fileMap:
    pipe fileMap [
      (targetAttrsValue targetNames)
      concatOfAttrs
    ];

  common = concatFileMap [
    "homeDirectory"
    "dotConfig"
    "dotLocalShare"
  ] layatFileMap;

  osSpecific =
    if isDarwin then
      concatFileMap [
        "homeDirectory"
        "dotConfig"
        "library"
      ] layatFileMap.MacOS
    else
      concatFileMap [
        "homeDirectory"
        "dotConfig"
      ] layatFileMap.Linux;
in
common // osSpecific

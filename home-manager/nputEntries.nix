# nput の home mode（root = homeRoot）entries を組み立てる共有モジュール。
#
# home-manager モジュール（home-manager/{linux,macos}/nput.nix）と flake-parts の
# nput profile（flake-parts/nput.nix）の両方から import される。HM の `config` に
# 依存しないよう、homeDirectory は呼び出し側が絶対パス文字列で渡す
# （HM 側は config.home.homeDirectory、flake-parts 側は flake-parts/nput.nix の
# 定義値を渡す。両者が食い違うと配置先がズレるので値は一致させること）。
#
# entries そのものは root 非依存（root は mkManifest / HM モジュールが homeRoot に
# pin する）ため、同じ entries から HM activation 用の manifest と CLI 用の
# flake output `nput.<system>.default` が同一内容で生成される。
{
  inputs,
  pkgs,
  homeDirectory,
  isDarwin,

  # repo の位置。既定は homeDirectory 配下だが、claude-web のように clone 先が
  # homeDirectory の外にあるプロファイルがあるので上書きできるようにしている。
  dotfilesDir ? "${homeDirectory}/dotfiles",

  # OS 共通で配置する target。nvim を使わないプロファイルは dotLocalShare
  # （treesitter parser）を落とすなど、プロファイル側で取捨選択する。
  commonTargets ? [
    "homeDirectory"
    "dotConfig"
    "dotLocalShare"
  ],
}:
let
  inherit (pkgs.lib) pipe;
  inherit (pkgs.stdenv.hostPlatform) system;
  myNurPkgs = inputs.yasunori-nur.legacyPackages.${system};
  inherit (myNurPkgs.lib.attrsets)
    targetAttrsValue
    concatOfAttrs
    ;
  inherit (inputs.nput.lib) mkOutOfStoreSymlink;

  # nput の src（out-of-store marker）には絶対パス文字列を渡す。
  homeDir = "${dotfilesDir}/home";
  xdgConfigHome = "${homeDir}/.config";

  nputFileMap = import ./nputFileMap.nix {
    inherit
      inputs
      pkgs
      mkOutOfStoreSymlink
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

  common = concatFileMap commonTargets nputFileMap;

  osSpecific =
    if isDarwin then
      concatFileMap [
        "homeDirectory"
        "dotConfig"
        "library"
      ] nputFileMap.MacOS
    else
      concatFileMap [
        "homeDirectory"
        "dotConfig"
      ] nputFileMap.Linux;
in
common // osSpecific

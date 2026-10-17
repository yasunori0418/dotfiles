# layat の home mode（root = homeRoot）entries を profile ごとに組み立てる共有モジュール。
#
# home-manager モジュール（home-manager/layat.nix）と flake-parts の layat profile
# （flake-parts/layat.nix）の両方から import される。返り値は
# `{ <profile 名> = entries; }` で、HM 側は `layat.configs.<name>.entries`、
# flake-parts 側は `perSystem.layat.<name>` へ同じ名前で配線する
# （profile 名を両経路で 1:1 に揃えないと、CLI 適用と HM activation が別 profile に
# なって同じ配置先を奪い合うため、名前はここから一箇所で決める）。
#
# 配置元は root 相対 marker で $HOME からの相対パスとして書くため、home ディレクトリの
# 絶対パスには依存しない。entries そのものは root 非依存（root は mkManifest / HM
# モジュールが homeRoot に pin する）。
#
# profile 間で同じ target を持つと eval 時の assert で止める。layat の `apply --all`
# 前段検査は名指しの `layat apply <name>` を通らないため、設計側で重複を弾く。
{
  inputs,
  pkgs,
  isDarwin,
}:
let
  inherit (pkgs) lib;
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

  # profile ごとに common と OS 固有を合成する。
  resolveProfile = profile: profile.common // (if isDarwin then profile.MacOS else profile.Linux);

  configs = lib.mapAttrs (_: resolveProfile) layatFileMap;

  # target（attr キー）が複数 profile に現れていないか。
  duplicatedTargets = lib.pipe configs [
    (lib.mapAttrsToList (name: entries: map (target: { inherit name target; }) (lib.attrNames entries)))
    lib.concatLists
    (lib.groupBy (x: x.target))
    (lib.filterAttrs (_: xs: builtins.length xs > 1))
    (lib.mapAttrsToList (target: xs: "${target} (${lib.concatMapStringsSep ", " (x: x.name) xs})"))
  ];
in
assert lib.assertMsg (duplicatedTargets == [ ]) ''
  layatEntries.nix: 同じ target が複数の layat profile に定義されています:
  ${lib.concatStringsSep "\n" (map (t: "  - ${t}") duplicatedTargets)}
'';
configs

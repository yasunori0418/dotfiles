# layat の home mode（root = homeRoot）entries を profile ごとに組み立てる共有モジュール。
#
# home-manager モジュール（home-manager/layat/default.nix）と flake-parts の layat profile
# （flake-parts/layat.nix）の両方から import される。返り値は
# `{ <profile 名> = entries; }` で、HM 側は `layat.configs.<name>.entries`、
# flake-parts 側は `perSystem.layat.<name>` へ同じ名前で配線する
# （profile 名を両経路で 1:1 に揃えないと、CLI 適用と HM activation が別 profile に
# なって同じ配置先を奪い合うため、名前はここから一箇所で決める）。
#
# profile の定義は ./profiles/<profile 名>.nix（1 profile 1 ファイル。ファイル名が
# そのまま profile 名 = `layat.configs.<name>` / `flake.layat.<system>.<name>`）。
# 各ファイルは `{ common; MacOS; Linux; }` を返し、OS の選択と合成はここで行う。
# ./profiles を readDir で列挙するので、ファイルを足せば profile が増える
# （Nix は git 管理下のファイルしか見ないため、新規ファイルは git add が要る）。
#
# profile の切り方は「rollback したい単位」と「apply / recopy を掛けたい範囲」:
#
#   - home:            ~/dotfiles/home の手書き設定のうち下記以外の全部（shell・git・CLI ツール等）
#   - desktop:         WM・GUI・テーマ・入力メソッド・壁紙（nixpkgs 由来の gtk css を含む）
#   - vim:             nvim / dpp / vim / ideavim と nixpkgs 由来の treesitter parser
#   - claude:          ~/.claude/ 配下の symlink 全部（CLAUDE.md・skills・agents・hooks・mcp-servers.json）
#   - claude-settings: ~/.claude/settings.json（method = "copy"）だけ。recopy の影響範囲をここに閉じる
#   - herdr-plugins:   ~/.local/share/herdr-plugins/*（herdr-plugin-link の対象）
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

  inherit (import ./lib.nix { inherit pkgs mkRootRelativeSymlink homeDir; })
    selectWallpaper
    fileMap
    ;

  # layat の symlink 配置はファイル/ディレクトリを区別しないため、旧 home.file 実装が
  # 持っていた homeDirMap/homeFileMap・xdgConfigDirMap/xdgConfigFileMap は各 1 つに統合する。
  homeMap = fileMap {
    dist = "";
    src = homeDir;
  };
  xdgConfigMap = fileMap {
    dist = ".config";
    src = xdgConfigHome;
  };

  # 各 profile ファイルに渡す引数。profile 側は必要なものだけ受け取る（`...` で残りを無視）。
  profileArgs = {
    inherit
      inputs
      pkgs
      lib
      mkRootRelativeSymlink
      homeDir
      xdgConfigHome
      homeMap
      xdgConfigMap
      selectWallpaper
      ;
  };

  # ./profiles/<name>.nix → { <name> = { common; MacOS; Linux; }; }
  profiles = lib.pipe (builtins.readDir ./profiles) [
    (lib.filterAttrs (file: type: type == "regular" && lib.hasSuffix ".nix" file))
    (lib.mapAttrs' (
      file: _:
      lib.nameValuePair (lib.removeSuffix ".nix" file) (import (./profiles + "/${file}") profileArgs)
    ))
  ];

  # profile ごとに common と OS 固有を合成する。
  resolveProfile = profile: profile.common // (if isDarwin then profile.MacOS else profile.Linux);

  configs = lib.mapAttrs (_: resolveProfile) profiles;

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
  layat/entries.nix: 同じ target が複数の layat profile に定義されています:
  ${lib.concatStringsSep "\n" (map (t: "  - ${t}") duplicatedTargets)}
'';
configs

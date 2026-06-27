{
  pkgs,
  mkOutOfStoreSymlink,
  homeDir,
}:
{
  /*
    壁紙の配置元を返す（nput の entry value 形式）

    type が `nixos-artwork` のときは nixos-artwork の store パスから配置する。
    nput の src は bare string を受け付けないため、derivation を src・store 内の
    相対パスを subpath に渡す store-backed entry にする。
    refer: https://github.com/NixOS/nixos-artwork/tree/master/wallpapers

    type が default または null のときは ~/dotfiles 配下の実体を
    out-of-store symlink で参照する。
  */
  selectWallpaper =
    {
      type,
      name,
    }:
    if type == "nixos-artwork" then
      {
        src = pkgs.nixos-artwork.wallpapers.${name};
        subpath = "share/backgrounds/nixos/nix-wallpaper-${name}.png";
      }
    else
      { src = mkOutOfStoreSymlink "${homeDir}/.background-image"; };

  /*
    ファイル/ディレクトリ配置をいい感じに nput.entries へマップする
    ```
    ".config/hoge/conf".src = mkOutOfStoreSymlink "${xdgConfigHome}/conf";
    ```
    ↑こういう記述が連続するのを減らせる
    配置元と配置先の命名が一致しているときだけ使える

    nput の symlink 配置はファイル/ディレクトリを区別しない（どちらも 1 本の
    symlink）ため、file-map.nix の is_recursive 相当の区別は不要。

    dist: 配置先（root からの相対。root は HM モジュールが homeRoot に pin する）
    src: ~/dotfiles 上のファイルパス（絶対パス文字列）
    return: ファイル名のリストが引数となる関数
  */
  fileMap =
    {
      dist,
      src,
    }:
    let
      f =
        files:
        builtins.foldl' (
          acc: file:
          let
            target = if dist == "" then "${file}" else "${dist}/${file}";
          in
          acc
          // {
            ${target}.src = mkOutOfStoreSymlink "${src}/${file}";
          }
        ) { } files;
    in
    f;
}

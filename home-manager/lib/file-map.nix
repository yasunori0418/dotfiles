{
  pkgs,
  symlink,
  homeDir,
}:
{
  selectWallpaper =
    {
      # type = (nixos-artwork | (default | null))
      type,

      /*
        type is `nixos-artwork` then select from nixos-artwork.
        mean name: nix-wallpaper-${name}.png
        refer: https://github.com/NixOS/nixos-artwork/tree/master/wallpapers

        type is default or null then must be set any value.
        e.g. name = "";
      */
      name,
    }:
    if type == "nixos-artwork" then
      "${pkgs.nixos-artwork.wallpapers.${name}}/share/backgrounds/nixos/nix-wallpaper-${name}.png"
    else
      (symlink /${homeDir}/.background-image);

  /*
    ファイル/ディレクトリ配置をいい感じにマップする
    ```
    ".config/hoge/conf" = {
      source = symlink /${xdgConfigHome}/conf;
      recursive = true;
    };
    ```
    ↑こういう記述が連続するのを減らせる
    配置元と配置先の命名が一致しているときだけ使える

    dist: 配置先
    src: dotfiles上のファイルパス
    is_recursive: ディレクトリを配置するときはtrue、ファイルを配置するときはfalse
    return: ファイル名のリストが引数となる関数
  */
  fileMap =
    {
      dist,
      src,
      is_recursive,
    }:
    let
      f =
        files:
        builtins.foldl' (
          acc: file:
          let
            distFile = if dist == "" then "${file}" else "${dist}/${file}";
          in
          acc
          // {
            ${distFile} = {
              source = symlink /${src}/${file};
              recursive = is_recursive;
            };
          }
        ) { } files;
    in
    f;
}

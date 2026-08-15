# herdr プラグイン `herdr-navigator` を「プラグインディレクトリ形状」でビルドする。
#
# 通常の Rust パッケージと違い $out/bin へ入れるだけでは動かない。
# herdr は plugin_root を cwd にして manifest の command を実行するが、
# herdr-navigator の herdr-plugin.toml は実行ファイルを
# `./target/release/herdr-navigator` という相対パスで指しているため、
# $out 直下に herdr-plugin.toml と target/release/<bin> が並ぶ形へ整形する。
# ($out がそのまま plugin_root になり、nput が symlink 配置する)
#
# バイナリは $out/bin にも置く（デバッグ時に直接叩けるようにするだけで、
# herdr 側は target/release の方を参照する）。
{
  lib,
  rustPlatform,
  src,
}:

rustPlatform.buildRustPackage {
  pname = "herdr-navigator";
  # flake input は default branch を追う（rev の pin は flake.lock）。
  # ここは upstream の Cargo.toml の version に合わせた目安。
  version = "0.3.6";

  inherit src;

  # Cargo.lock 由来の vendor hash。`nix flake update herdr-navigator` で
  # Cargo.lock が変わるとここが合わなくなりビルドが落ちるので、
  # hash mismatch が出す `got:` の値へ差し替える。
  cargoHash = "sha256-1fvQ8hyarP1WQwqIRvqKCkttwAMj3wGieue91/VNll8=";

  # ビルド済みバイナリを target/release/ へ据え直す。buildRustPackage の
  # 既定 installPhase は $out/bin にしか置かないため上書きする。
  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/target/release
    install -Dm555 "$(find target -name herdr-navigator -type f -perm -u+x | head -n1)" \
      $out/target/release/herdr-navigator
    ln -s $out/target/release/herdr-navigator $out/bin/herdr-navigator
    install -Dm444 herdr-plugin.toml $out/herdr-plugin.toml

    runHook postInstall
  '';

  meta = {
    description = "Jump to any Herdr workspace, agent, project, session, remote, directory, or action from one fuzzy navigator";
    homepage = "https://github.com/thanhdat77/herdr-navigator";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    mainProgram = "herdr-navigator";
  };
}

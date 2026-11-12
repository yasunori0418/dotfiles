# https://github.com/NixOS/nixpkgs/pull/585611 が nixos-unstable に届くまでの暫定。
# cargoSetupHook が LIBGIT2_NO_VENDOR=1 を立てるようになり、build-dependency の shadow-rs → git2 が
# システムの libgit2 を pkg-config で探して失敗するため、両方を入力に足す
final: prev: {
  clipcat = prev.clipcat.overrideAttrs (oldAttrs: {
    nativeBuildInputs = oldAttrs.nativeBuildInputs ++ [ prev.pkg-config ];
    buildInputs = (oldAttrs.buildInputs or [ ]) ++ [ prev.libgit2 ];
  });
}

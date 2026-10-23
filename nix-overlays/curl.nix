(final: prev: {
  # https://github.com/NixOS/nixpkgs/pull/574255 (master 側は #574057) が nixpkgs-unstable に届くまでの暫定。
  # curlMinimal を上書きすると fetchurl 経由でほぼ全パッケージが再ビルドになるため curlFull に限定する
  curlFull = prev.curlFull.overrideAttrs (
    finalAttrs: oldAttrs: {
      version = "8.23.0";
      src = prev.fetchurl {
        urls = [
          "https://curl.haxx.se/download/curl-${finalAttrs.version}.tar.xz"
          "https://github.com/curl/curl/releases/download/curl-${
            builtins.replaceStrings [ "." ] [ "_" ] finalAttrs.version
          }/curl-${finalAttrs.version}.tar.xz"
        ];
        hash = "sha256-ja3X0lNqMU+YKtBaZRtxP0Jr99Aswsds/7l5byIY5sU=";
      };
    }
  );
})

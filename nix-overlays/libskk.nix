(final: prev: {
  libskk = prev.libskk.overrideAttrs (oldAttrs: {
    # https://github.com/NixOS/nixpkgs/pull/354218
    patches = [
      # fix parse error in default.json
      # https://github.com/ueno/libskk/pull/90
      (prev.fetchpatch {
        url = "https://github.com/ueno/libskk/commit/2382ebedc8dca88e745d223ad7badb8b73bbb0de.diff";
        sha256 = "sha256-e1bKVteNjqmr40XI82Qar63LXPWYIfnUVlo5zQSkPNw=";
      })
    ];
  });
})

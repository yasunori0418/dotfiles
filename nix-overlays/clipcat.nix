(final: prev: {
  # rustc 1.99 で削除された lint の指定が workspace.lints の
  # renamed_and_removed_lints = "deny" によりビルドを失敗させるため、上流の修正を当てる
  clipcat = prev.clipcat.overrideAttrs (oldAttrs: {
    patches = (oldAttrs.patches or [ ]) ++ [
      (prev.fetchpatch {
        name = "drop-removed-lint.patch";
        url = "https://github.com/xrelkd/clipcat/commit/9761d95bfa267cb1c5b28ac27c4b63572b915f04.patch";
        hash = "sha256-ODpwBAtSCDM6M9WCxWvpl/P2DyJPNQnPj8MNEXJbbCQ=";
      })
      (prev.fetchpatch {
        name = "remove-deprecated-linter-options.patch";
        url = "https://github.com/xrelkd/clipcat/commit/424fcef2d4e98a256d2897a2e901a9f7d28f0fd6.patch";
        hash = "sha256-YiH0oHiEhJvfzeS6FOC+2rpCHpPXVIY0dE6vkpwicSw=";
      })
    ];
  });
})

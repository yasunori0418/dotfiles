(final: prev: {
  # rustc 1.99 で no_mangle_generic_items / repr_transparent_non_zst_fields が
  # hard error 化されて lint から削除され、workspace.lints の
  # renamed_and_removed_lints = "deny" によりビルドが失敗するため、削除済み lint の指定を外す
  clipcat = prev.clipcat.overrideAttrs (oldAttrs: {
    postPatch = (oldAttrs.postPatch or "") + ''
      sed -i \
        -e '/^no_mangle_generic_items[[:space:]]*=/d' \
        -e '/^repr_transparent_non_zst_fields[[:space:]]*=/d' \
        Cargo.toml
    '';
  });
})

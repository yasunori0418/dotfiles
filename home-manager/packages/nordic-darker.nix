# nixpkgs の `nordic` は 2026-07-22 に削除された（GTK2 依存の
# `gtk-engine-murrine` が削除されたため）。GTK3/4 のテーマとしては
# 引き続き使えるので、利用している Nordic-darker のみを自前で配置する。
# refer: https://github.com/EliverLara/Nordic
{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  jdupes,
}:

stdenvNoCC.mkDerivation {
  pname = "nordic-darker";
  version = "2.2.0-unstable-2025-05-05";

  src = fetchFromGitHub {
    owner = "EliverLara";
    repo = "nordic";
    rev = "bf05d41c7c7cd03e391854739bcc843fc6053ced";
    hash = "sha256-AjVvciUrm/X3U6Pmo52ZrucLRJdsRFPeEMRwSKyjwi4=";
    name = "Nordic-darker";
  };

  nativeBuildInputs = [ jdupes ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/themes/Nordic-darker
    cp -a . $out/share/themes/Nordic-darker

    # remove uneeded files
    theme=$out/share/themes/Nordic-darker
    rm -r $theme/.gitignore
    rm -r $theme/Art
    rm -r $theme/LICENSE
    rm -r $theme/README.md
    rm -r $theme/{package.json,package-lock.json,Gulpfile.js}
    rm -r $theme/src
    rm -r $theme/cinnamon/*.scss
    rm -r $theme/gnome-shell/{earlier-versions,extensions,*.scss}
    rm -r $theme/gtk-2.0/{assets.svg,assets.txt,links.fish,render-assets.sh}
    rm -r $theme/gtk-3.0/{apps,widgets,*.scss}
    rm -r $theme/gtk-4.0/{apps,widgets,*.scss}
    rm -r $theme/xfwm4/{assets,render_assets.fish}

    # Replace duplicate files with symbolic links to the first file in
    # each set of duplicates, reducing the installed size
    jdupes --quiet --link-soft --recurse $out/share

    # FIXME: https://github.com/EliverLara/Nordic/issues/331
    echo "Removing broken symlinks ..."
    find $out -xtype l -print -delete

    runHook postInstall
  '';

  meta = {
    description = "Gtk theme using the Nord color pallete (Nordic-darker variant)";
    homepage = "https://github.com/EliverLara/Nordic";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.all;
  };
}

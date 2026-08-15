# herdr プラグイン `worktrunk` を「プラグインディレクトリ形状」で配置する。
#
# 中身は bash スクリプトのみでビルド不要だが、derivation を挟んで store 直結
# （read-only）にする。プラグイン本体は plugin_root へ書き込まず設定は
# $HERDR_PLUGIN_CONFIG_DIR、状態は $HERDR_PLUGIN_STATE_DIR に置く作りなので
# read-only で問題なく動く。
#
# スクリプトは jq / fzf / wt / git を PATH から解決する。makeWrapper で
# PATH を固定すると wt 側の設定追従（ユーザーの worktrunk 設定）が壊れうるため
# あえて包まず、環境の PATH に任せる。
{
  lib,
  stdenvNoCC,
  src,
}:

stdenvNoCC.mkDerivation {
  pname = "herdr-worktrunk";
  # flake input は default branch を追う（rev の pin は flake.lock）。
  # ここは upstream の最新リリースタグに合わせた目安。
  version = "0.5.0";

  inherit src;

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    install -Dm444 herdr-plugin.toml $out/herdr-plugin.toml
    for script in config.sh helpers.sh picker.sh remove.sh; do
      install -Dm555 "$script" "$out/$script"
    done

    runHook postInstall
  '';

  meta = {
    description = "Switch, create, or remove git worktrees via worktrunk (herdr plugin)";
    homepage = "https://github.com/devashish2203/herdr-worktrunk";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
  };
}

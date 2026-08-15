# herdr プラグイン `cloudmanic.herdr-plus` を「プラグインディレクトリ形状」でビルドする。
#
# manifest は実行ファイルを ./bin/herdr-plus と相対参照する（herdr は
# plugin_root を cwd にして command を実行する）。buildGoModule の既定の
# installPhase が $out/bin へ置くので、$out 直下に herdr-plugin.toml を足すだけで
# plugin_root として成立する（herdr-navigator と違い target/ への据え直しは不要）。
#
# upstream の [[build]]（scripts/build.sh）は Go が無ければ GitHub Releases の
# prebuilt を落としてくる作りだが、ここでは Nix がソースからビルドするので
# その経路は使わない。
#
# 設定は HERDR_PLUGIN_CONFIG_DIR（未設定時は ~/.config/herdr-plus）を読み、
# plugin_root へは書き込まないので store 直結（read-only）で動く。
{
  lib,
  buildGoModule,
  src,
}:

buildGoModule {
  pname = "herdr-plus";
  # flake input は default branch を追う（rev の pin は flake.lock）。
  # ここは upstream の herdr-plugin.toml の version に合わせた目安。
  version = "0.1.20";

  inherit src;

  # go.sum 由来の vendor hash。`nix flake update herdr-plus` で go.sum が
  # 変わるとここが合わなくなりビルドが落ちるので、
  # hash mismatch が出す `got:` の値へ差し替える。
  vendorHash = "sha256-im2gPhLarMf1w/8rhxbOe9EhUdvseffukT9tqU4EEXI=";

  # TUI を含むため実行にターミナルが要る。ビルド時のテストは走らせない。
  doCheck = false;

  postInstall = ''
    install -Dm444 $src/herdr-plugin.toml $out/herdr-plugin.toml
  '';

  meta = {
    description = "An extension for herdr — Projects (declarative workspace templates) and Quick Actions (fuzzy launcher for one-off scripts)";
    homepage = "https://github.com/cloudmanic/herdr-plus";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    mainProgram = "herdr-plus";
  };
}

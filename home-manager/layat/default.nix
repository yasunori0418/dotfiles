{
  inputs,
  pkgs,
  ...
}:
let
  inherit (pkgs) lib;
  inherit (pkgs.stdenv.hostPlatform) system isDarwin;

  # entries の組み立ては flake-parts の layat profile と共有する
  # （./entries.nix・同じ `{ <name> = { subdir; entries; }; }` から HM activation 用の
  # manifest と flake output `layat.<system>.<name>` が生成される）。
  configs = import ./entries.nix {
    inherit inputs pkgs isDarwin;
  };
in
{
  layat = {
    enable = true;
    # profile 名ごとに独立した link-farm と generation profile になる。
    # jobs / recopy / backup は既定のまま（recopy は Makefile の
    # `layat apply claude-settings --recopy` で profile を限定して掛ける）。
    # subdir は HM モジュールが `homeRoot { subdir }` へ配線する（null なら $HOME 直下基点）。
    configs = lib.mapAttrs (_: config: { inherit (config) subdir entries; }) configs;
  };
  home.packages = [ inputs.layat.packages.${system}.layat ];
}

{ pkgs, ... }:
{
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        editor = false;
        configurationLimit = 5;
      };
      efi.canTouchEfiVariables = true;
      timeout = 3;
    };
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    tmp = {
      cleanOnBoot = true;
      useTmpfs = false;
    };
  };

  # NOTE: linux_zen が bzImage ではなく vmlinuz を出力する nixpkgs の回帰バグへの一時回避策。
  # 修正 (nixpkgs#536173, linux_zen 7.1.2) は master へマージ済みだが nixos-unstable へは未伝播。
  # 進捗: https://nixpk.gs/pr-tracker.html?pr=536173
  # 修正が降りてきたらこのブロックを削除する。
  system.boot.loader.kernelFile = "vmlinuz";
}

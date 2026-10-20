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
    # Workaround: https://github.com/NixOS/nixpkgs/issues/575192
    # zenpower が .ko.cer を出さず aggregateModules が失敗するため modules_install 経由にする
    kernelPackages = pkgs.linuxKernel.packages.linux_zen.extend (
      lpFinal: lpPrev: {
        zenpower = lpPrev.zenpower.overrideAttrs (old: {
          makeFlags =
            lpFinal.kernelModuleMakeFlags
            ++ old.makeFlags
            ++ [
              "INSTALL_MOD_PATH=${placeholder "out"}"
              "INSTALL_MOD_DIR=kernel/drivers/hwmon/zenpower"
              "INSTALL_MOD_STRIP=1"
              "DEPMOD=true"
            ];
          installPhase = null;
          installTargets = [ "modules_install" ];
          installFlags = [
            "-C"
            "${lpFinal.kernel.dev}/lib/modules/${lpFinal.kernel.modDirVersion}/build"
            "M=$(PWD)"
          ];
        });
      }
    );
    tmp = {
      cleanOnBoot = true;
      useTmpfs = false;
    };
  };
}

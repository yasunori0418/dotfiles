{ pkgs, ... }:
{
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        editor = false;
      };
      efi.canTouchEfiVariables = true;
      timeout = 3;
    };
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    tmp = {
      cleanOnBoot = true;
      useTmpfs = true;
    };
  };
}

{ pkgs }:
{
  loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };
  kernelPackages = pkgs.linuxKernel.packages.linux_zen;
}

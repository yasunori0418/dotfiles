{pkgs, ...}: {
  loader.systemd-boot.enable = true;
  loader.efi.canTouchEfiVariables = true;
  kernelPackages = pkgs.linuxKernel.packages.linux_zen;
}

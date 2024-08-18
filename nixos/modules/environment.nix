{pkgs, ...}: {
  systemPackages = with pkgs; [
    vim
    exfat
  ];
}

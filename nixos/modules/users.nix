{pkgs, ...}: {
  users.yasunori = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "yasunori";
    extraGroups = ["networkmanager" "wheel"];
  };
}

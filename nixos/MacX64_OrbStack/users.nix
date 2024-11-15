{ pkgs, ... }:
{
  programs.zsh.enable = true;
  users = {
    users.watanabe = {
      uid = 502;
      extraGroups = [ "wheel" ];

      # simulate isNormalUser, but with an arbitrary UID
      isSystemUser = true;
      group = "users";
      shell = pkgs.zsh;
      createHome = true;
      home = "/home/watanabe";
    };
    # This being `true` leads to a few nasty bugs, change at your own risk!
    mutableUsers = false;
  };
  security.sudo.wheelNeedsPassword = false;
}

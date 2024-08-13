{ pkgs, ... }: {
  programs.zsh.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.yasunori = {
    isNormalUser = true;
    shell = pkgs.zsh;
    description = "yasunori";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      git
      wezterm
      lemonade
      deno
      gnumake
      gcc
      clang
      zig
      ncurses
      xsel
    ];
  };

}

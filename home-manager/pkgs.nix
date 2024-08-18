{ pkgs, ... }: {
  home.packages = with pkgs; [
    git
    # wezterm
    lemonade
    deno
    gnumake
    gcc
    rust
    ncurses
    unzip
  ];
}

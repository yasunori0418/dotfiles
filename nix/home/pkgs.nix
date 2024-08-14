{ pkgs, ... }: {
  home.packages = with pkgs; [
    git
    wezterm
    lemonade
    deno
    gnumake
    gcc
    # clang
    zig
    ncurses
  ];
}

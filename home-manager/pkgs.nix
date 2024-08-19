{ pkgs, ... }:
{
  home.packages = with pkgs; [
    git
    wezterm
    kitty
    lemonade
    deno
    gnumake
    gcc
    ncurses
    unzip
    rustup
    luajitPackages.luarocks
  ];
}

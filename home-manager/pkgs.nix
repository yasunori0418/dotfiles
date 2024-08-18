{ pkgs, ... }:
{
  home.packages = with pkgs; [
    git
    wezterm
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

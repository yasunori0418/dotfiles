{ pkgs, ... }:
{
  home.packages = with pkgs; [
    git
    wezterm
    kitty
    alacritty
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

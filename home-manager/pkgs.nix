{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # wezterm
    kitty
    alacritty
    lemonade
    deno
    gcc
    ncurses
    unzip
    rustup
    luajitPackages.luarocks
  ];
}

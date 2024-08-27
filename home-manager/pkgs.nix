{ pkgs, wezterm-flake, ... }:
{
  home.packages =
    with pkgs;
    [
      kitty
      alacritty
      lemonade
      deno
      gcc
      ncurses
      unzip
      rustup
      luajitPackages.luarocks
    ]
    ++ [ wezterm-flake.packages.${pkgs.system}.default ];
}

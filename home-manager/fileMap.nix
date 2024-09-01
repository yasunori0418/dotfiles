{
  flakeRoot,
  homeDir,
  xdgConfigHome,
  ...
}:
{
  home.file = {
    ".docker" = {
      source = /${homeDir}/.docker;
      recursive = true;
    };
    ".icons" = {
      source = /${homeDir}/.icons;
      recursive = true;
    };
    ".Xresources.d" = {
      source = /${homeDir}/.Xresources.d;
      recursive = true;
    };
    ".zsh" = {
      source = /${homeDir}/.zsh;
      recursive = true;
    };
    "bin" = {
      source = /${flakeRoot}/bin;
      recursive = true;
    };
    ".Xresources".source = /${homeDir}/.Xresources;
    ".zshenv".source = /${homeDir}/.zshenv;
    ".zshrc".source = /${homeDir}/.zshrc;
    ".zprofile".source = /${homeDir}/.zprofile;
    ".p10k.zsh".source = /${homeDir}/.p10k.zsh;
    ".xprofile".source = /${homeDir}/.xprofile;
    ".xinitrc".source = /${homeDir}/.xinitrc;
    ".xserverrc".source = /${homeDir}/.xserverrc;
    ".textlintrc.yaml".source = /${homeDir}/.textlintrc.yaml;
    ".pam_environment".source = /${homeDir}/.pam_environment;
    ".gtkrc-2.0".source = /${homeDir}/.gtkrc-2.0;
    ".face".source = /${homeDir}/.face;
    ".dir_colors".source = /${homeDir}/.dir_colors;
    ".bashrc".source = /${homeDir}/.bashrc;
    ".bash_profile".source = /${homeDir}/.bash_profile;
    ".bash_logout".source = /${homeDir}/.bash_logout;
    "bun.lockb".source = /${homeDir}/bun.lockb;
    "package.json".source = /${homeDir}/package.json;

    ".config/aerospace" = {
      source = /${xdgConfigHome}/aerospace;
      recursive = true;
    };
    ".config/aqua" = {
      source = /${xdgConfigHome}/aqua;
      recursive = true;
    };
    ".config/bumblebee-status" = {
      source = /${xdgConfigHome}/bumblebee-status;
      recursive = true;
    };
    ".config/cantata" = {
      source = /${xdgConfigHome}/cantata;
      recursive = true;
    };
    ".config/dunst" = {
      source = /${xdgConfigHome}/dunst;
      recursive = true;
    };
    ".config/fastfetch" = {
      source = /${xdgConfigHome}/fastfetch;
      recursive = true;
    };
    ".config/fcitx5" = {
      source = /${xdgConfigHome}/fcitx5;
      recursive = true;
    };
    ".config/fd" = {
      source = /${xdgConfigHome}/fd;
      recursive = true;
    };
    ".config/git" = {
      source = /${xdgConfigHome}/git;
      recursive = true;
    };
    ".config/gtk-2.0" = {
      source = /${xdgConfigHome}/gtk-2.0;
      recursive = true;
    };
    ".config/gtk-3.0" = {
      source = /${xdgConfigHome}/gtk-3.0;
      recursive = true;
    };
    ".config/i3" = {
      source = /${xdgConfigHome}/i3;
      recursive = true;
    };
    ".config/jj" = {
      source = /${xdgConfigHome}/jj;
      recursive = true;
    };
    ".config/karabiner" = {
      source = /${xdgConfigHome}/karabiner;
      recursive = true;
    };
    ".config/keynav" = {
      source = /${xdgConfigHome}/keynav;
      recursive = true;
    };
    ".config/kitty" = {
      source = /${xdgConfigHome}/kitty;
      recursive = true;
    };
    ".config/libskk" = {
      source = /${xdgConfigHome}/libskk;
      recursive = true;
    };
    ".config/luacheck" = {
      source = /${xdgConfigHome}/luacheck;
      recursive = true;
    };
    ".config/mise" = {
      source = /${xdgConfigHome}/mise;
      recursive = true;
    };
    ".config/mpd" = {
      source = /${xdgConfigHome}/mpd;
      recursive = true;
    };
    ".config/neofetch" = {
      source = /${xdgConfigHome}/neofetch;
      recursive = true;
    };
    ".config/nvim" = {
      source = /${xdgConfigHome}/nvim;
      recursive = true;
    };
    ".config/paru" = {
      source = /${xdgConfigHome}/paru;
      recursive = true;
    };
    ".config/picom" = {
      source = /${xdgConfigHome}/picom;
      recursive = true;
    };
    ".config/rofi" = {
      source = /${xdgConfigHome}/rofi;
      recursive = true;
    };
    ".config/sheldon" = {
      source = /${xdgConfigHome}/sheldon;
      recursive = true;
    };
    ".config/sketchybar" = {
      source = /${xdgConfigHome}/sketchybar;
      recursive = true;
    };
    ".config/skhd" = {
      source = /${xdgConfigHome}/skhd;
      recursive = true;
    };
    ".config/systemd" = {
      source = /${xdgConfigHome}/systemd;
      recursive = true;
    };
    ".config/vim" = {
      source = /${xdgConfigHome}/vim;
      recursive = true;
    };
    ".config/wezterm" = {
      source = /${xdgConfigHome}/wezterm;
      recursive = true;
    };
    ".config/xremap" = {
      source = /${xdgConfigHome}/xremap;
      recursive = true;
    };
    ".config/yabai" = {
      source = /${xdgConfigHome}/yabai;
      recursive = true;
    };
    ".config/yamllint" = {
      source = /${xdgConfigHome}/yamllint;
      recursive = true;
    };
    ".config/zeno" = {
      source = /${xdgConfigHome}/zeno;
      recursive = true;
    };
    ".config/ncpamixer.conf".source = /${xdgConfigHome}/ncpamixer.conf;
    ".config/screenkey.json".source = /${xdgConfigHome}/screenkey.json;
  };
}

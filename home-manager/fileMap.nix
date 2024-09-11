{
  config,
  dotfiles,
  homeDir,
  xdgConfigHome,
  ...
}:
let
  symlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  homeDirectory = {
    ".zsh" = {
      source = (symlink /${homeDir}/.zsh);
      recursive = true;
    };
    "bin" = {
      source = (symlink /${dotfiles}/bin);
      recursive = true;
    };
    ".zshenv".source = (symlink /${homeDir}/.zshenv);
    ".zshrc".source = (symlink /${homeDir}/.zshrc);
    ".p10k.zsh".source = (symlink /${homeDir}/.p10k.zsh);
    ".textlintrc.yaml".source = (symlink /${homeDir}/.textlintrc.yaml);
    ".dir_colors".source = (symlink /${homeDir}/.dir_colors);
    ".bashrc".source = (symlink /${homeDir}/.bashrc);
    ".bash_profile".source = (symlink /${homeDir}/.bash_profile);
    ".bash_logout".source = (symlink /${homeDir}/.bash_logout);
    "bun.lockb".source = (symlink /${homeDir}/bun.lockb);
    "package.json".source = (symlink /${homeDir}/package.json);
  };

  xdgConfigHome = {
    ".config/fastfetch" = {
      source = (symlink /${xdgConfigHome}/fastfetch);
      recursive = true;
    };
    ".config/fd" = {
      source = (symlink /${xdgConfigHome}/fd);
      recursive = true;
    };
    ".config/git" = {
      source = (symlink /${xdgConfigHome}/git);
      recursive = true;
    };
    ".config/jj" = {
      source = (symlink /${xdgConfigHome}/jj);
      recursive = true;
    };
    ".config/kitty" = {
      source = (symlink /${xdgConfigHome}/kitty);
      recursive = true;
    };
    ".config/luacheck" = {
      source = (symlink /${xdgConfigHome}/luacheck);
      recursive = true;
    };
    ".config/neofetch" = {
      source = (symlink /${xdgConfigHome}/neofetch);
      recursive = true;
    };
    ".config/nvim" = {
      source = (symlink /${xdgConfigHome}/nvim);
      recursive = true;
    };
    ".config/vim" = {
      source = (symlink /${xdgConfigHome}/vim);
      recursive = true;
    };
    ".config/sheldon" = {
      source = (symlink /${xdgConfigHome}/sheldon);
      recursive = true;
    };
    ".config/yamllint" = {
      source = (symlink /${xdgConfigHome}/yamllint);
      recursive = true;
    };
    ".config/zeno" = {
      source = (symlink /${xdgConfigHome}/zeno);
      recursive = true;
    };
    ".config/wezterm" = {
      source = (symlink /${xdgConfigHome}/wezterm);
      recursive = true;
    };
  };

  MacOS = {
    homeDirectory = {
      ".docker/config.json".source = (symlink /${homeDir}/.docker/mac_config.json);
    };
    xdgConfigHome = {
      ".config/aerospace" = {
        source = (symlink /${xdgConfigHome}/aerospace);
        recursive = true;
      };
      ".config/karabiner" = {
        source = (symlink /${xdgConfigHome}/karabiner);
        recursive = true;
      };
      ".config/sketchybar" = {
        source = (symlink /${xdgConfigHome}/sketchybar);
        recursive = true;
      };
      ".config/skhd" = {
        source = (symlink /${xdgConfigHome}/skhd);
        recursive = true;
      };
      ".config/yabai" = {
        source = (symlink /${xdgConfigHome}/yabai);
        recursive = true;
      };
    };
  };

  Linux = {
    homeDirectory = {
      ".docker/config.json".source = (symlink /${homeDir}/.docker/linux_config.json);
      ".icons" = {
        source = (symlink /${homeDir}/.icons);
        recursive = true;
      };
      # ".Xresources.d" = {
      #   source = (symlink /${homeDir}/.Xresources.d);
      #   recursive = true;
      # };
      # ".Xresources".source = (symlink /${homeDir}/.Xresources);
      ".xprofile".source = (symlink /${homeDir}/.xprofile);
      ".xinitrc".source = (symlink /${homeDir}/.xinitrc);
      ".xserverrc".source = (symlink /${homeDir}/.xserverrc);
      ".pam_environment".source = (symlink /${homeDir}/.pam_environment);
      ".gtkrc-2.0".source = (symlink /${homeDir}/.gtkrc-2.0);
      ".face".source = (symlink /${homeDir}/.face);
    };
    xdgConfigHome = {
      ".config/bumblebee-status" = {
        source = (symlink /${xdgConfigHome}/bumblebee-status);
        recursive = true;
      };
      ".config/cantata" = {
        source = (symlink /${xdgConfigHome}/cantata);
        recursive = true;
      };
      ".config/dunst" = {
        source = (symlink /${xdgConfigHome}/dunst);
        recursive = true;
      };
      ".config/fcitx5" = {
        source = (symlink /${xdgConfigHome}/fcitx5);
        recursive = true;
      };
      ".config/gtk-2.0" = {
        source = (symlink /${xdgConfigHome}/gtk-2.0);
        recursive = true;
      };
      ".config/gtk-3.0" = {
        source = (symlink /${xdgConfigHome}/gtk-3.0);
        recursive = true;
      };
      ".config/i3" = {
        source = (symlink /${xdgConfigHome}/i3);
        recursive = true;
      };
      ".config/keynav" = {
        source = (symlink /${xdgConfigHome}/keynav);
        recursive = true;
      };
      ".config/libskk" = {
        source = (symlink /${xdgConfigHome}/libskk);
        recursive = true;
      };
      ".config/mpd" = {
        source = (symlink /${xdgConfigHome}/mpd);
        recursive = true;
      };
      ".config/paru" = {
        source = (symlink /${xdgConfigHome}/paru);
        recursive = true;
      };
      ".config/picom" = {
        source = (symlink /${xdgConfigHome}/picom);
        recursive = true;
      };
      ".config/rofi" = {
        source = (symlink /${xdgConfigHome}/rofi);
        recursive = true;
      };
      ".config/systemd" = {
        source = (symlink /${xdgConfigHome}/systemd);
        recursive = true;
      };
      ".config/xremap" = {
        source = (symlink /${xdgConfigHome}/xremap);
        recursive = true;
      };
      ".config/ncpamixer.conf".source = (symlink /${xdgConfigHome}/ncpamixer.conf);
      ".config/screenkey.json".source = (symlink /${xdgConfigHome}/screenkey.json);
    };
  };
}

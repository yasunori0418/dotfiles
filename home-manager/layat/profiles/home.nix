# profile `home`: ~/dotfiles/home の手書き設定のうち desktop / vim / claude 以外の全部
# （shell・git・CLI ツール・ターミナル等）。
{
  homeDir,
  xdgConfigHome,
  mkRootRelativeSymlink,
  homeMap,
  xdgConfigMap,
  ...
}:
{
  common =
    homeMap [
      # keep-sorted start
      ".bash_logout"
      ".bash_profile"
      ".bashrc"
      ".dir_colors"
      ".p10k.zsh"
      ".screenrc"
      ".zsh"
      ".zshenv"
      ".zshrc"
      "bin"
      # keep-sorted end
    ]
    // xdgConfigMap [
      # keep-sorted start
      "alacritty/alacritty.toml"
      "alacritty/keybinds"
      "alacritty/nord.toml"
      "clipcat"
      "direnv"
      "fastfetch"
      "fd"
      "ghostty/clipboard.conf"
      "ghostty/command.conf"
      "ghostty/config"
      "ghostty/core.conf"
      "ghostty/font.conf"
      "ghostty/keybinds.conf"
      "ghostty/mouse.conf"
      "ghostty/quick.conf"
      "ghostty/resize.conf"
      "ghostty/theme.conf"
      "ghostty/window.conf"
      "git"
      "glow"
      "gwq"
      "herdr/config.toml"
      # herdr-plus の設定一式。config.toml 以外の 3 つはディレクトリごと配置する
      # （quick-actions/ は「ディレクトリが無いとき」だけ herdr-plus が例を seed
      # するので、symlink が先にあれば seed されない）。
      "herdr/plugins/config/cloudmanic.herdr-plus/config.toml"
      "herdr/plugins/config/cloudmanic.herdr-plus/projects"
      "herdr/plugins/config/cloudmanic.herdr-plus/quick-actions"
      "herdr/plugins/config/cloudmanic.herdr-plus/worktrees"
      "herdr/plugins/config/herdr-navigator/config.toml"
      # config.toml の [[keys.command]] から呼ぶスクリプト。TOML に直書きすると
      # sh の引用が多重エスケープになって読めないものはここへ出す。
      "herdr/scripts"
      "jj"
      "kanata"
      "kitty"
      "laminate"
      "ov"
      "sheldon"
      "shellcheckrc"
      "sqls"
      "textlint"
      "tirith"
      "tmux"
      "typos"
      "wezterm"
      "worktrunk"
      "yamllint"
      "zellij"
      "zeno"
      # keep-sorted end
    ];
  MacOS = {
    # ".docker/config.json".src = mkRootRelativeSymlink "${homeDir}/.docker/mac_config.json";
    ".config/alacritty/os.toml".src = mkRootRelativeSymlink "${xdgConfigHome}/alacritty/mac.toml";
    "Library/Application Support/arto".src = mkRootRelativeSymlink "${xdgConfigHome}/arto";
    "Library/Application Support/Code/User/settings.json".src =
      mkRootRelativeSymlink "${xdgConfigHome}/Code/User/settings.json";
    "Library/Application Support/Luacheck/.luacheckrc".src =
      mkRootRelativeSymlink "${xdgConfigHome}/luacheck/.luacheckrc";
  }
  // xdgConfigMap [
    "ghostty/macos.conf"
  ];
  Linux = {
    ".docker/config.json".src = mkRootRelativeSymlink "${homeDir}/.docker/linux_config.json";
    ".config/alacritty/os.toml".src = mkRootRelativeSymlink "${xdgConfigHome}/alacritty/linux.toml";
  }
  // homeMap [
    ".pam_environment"
  ]
  // xdgConfigMap [
    # keep-sorted start
    "Code/User/settings.json"
    "arto"
    "environment.d/my-env.conf"
    "ghostty/linux.conf"
    "luacheck"
    "paru"
    # keep-sorted end
  ];
}

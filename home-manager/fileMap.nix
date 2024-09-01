{
  flakeRoot,
  homeDir,
  # xdgConfigHome,
  ...
}:
{
  home.file = {
    ".docker".source = /${homeDir}/.docker;
    ".icons".source = /${homeDir}/.icons;
    ".Xresources".source = /${homeDir}/.Xresources;
    ".Xresources.d".source = /${homeDir}/.Xresources.d;
    ".zsh".source = /${homeDir}/.zsh;
    ".zshenv".source = /${homeDir}/.zshenv;
    ".zshrc".source = /${homeDir}/.zshrc;
    ".zprofile".source = /${homeDir}/.zprofile;
    ".p10k.zsh".source = /${homeDir}/.p10k.zsh;
    ".xprofile".source = /${homeDir}/.xprofile;
    ".xinitrc".source = /${homeDir}/.xinitrc;
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
    "bin".source = /${flakeRoot}/bin;
  };
}

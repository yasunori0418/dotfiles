#!/usr/bin/env -S bash

cd "${HOME}"

unlink .docker/config.json
unlink .icons/
unlink .Xresources.d/
unlink .zsh/
unlink .bash_logout
unlink .bash_profile
unlink .bashrc
unlink .dir_colors
unlink .face
unlink .gtkrc-2.0
unlink .p10k.zsh
unlink .pam_environment
unlink .textlintrc.yaml
unlink .xinitrc
unlink .xprofile
unlink .Xresources
unlink .xserverrc
# unlink .zprofile  mac環境: 意図していないaliasやら環境変数を差し込んでいる。
unlink .zshenv
unlink .zshrc
unlink bun.lockb
unlink package.json
unlink bin

# cd "${HOME}/.config"
#
# unlink aerospace
# unlink aqua
# unlink bumblebee-status
# unlink cantata
# unlink dunst
# unlink fastfetch
# unlink fcitx5
# unlink fd
# unlink git
# unlink gtk-2.0
# unlink gtk-3.0
# unlink i3
# unlink jj
# unlink karabiner
# unlink keynav
# unlink kitty
# unlink libskk
# unlink luacheck
# unlink mise
# unlink mpd
# unlink neofetch
# unlink nvim
# unlink paru
# unlink picom
# unlink rofi
# unlink sheldon
# unlink sketchybar
# unlink skhd
# unlink systemd
# unlink vim
# unlink wezterm
# unlink xremap
# unlink yabai
# unlink yamllint
# unlink zeno
# unlinkamixer.conf
# unlink screenkey.json

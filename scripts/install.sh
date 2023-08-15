#!/usr/bin/env bash

set -e -u -o pipefail

echo '     _       _    __ _ _           '
echo '  __| | ___ | |_ / _(_) | ___  ___ '
echo ' / _` |/ _ \| __| |_| | |/ _ \/ __|'
echo '| (_| | (_) | |_|  _| | |  __/\__ \'
echo ' \__,_|\___/ \__|_| |_|_|\___||___/'

echo '  _            '
echo ' | |__  _   _  '
echo ' | |_ \| | | | '
echo ' | |_) | |_| | '
echo ' |_.__/ \__, | '
echo '        |___/  '

echo '                                        _ '
echo ' _   _  __ _ ___ _   _ _ __   ___  _ __(_)'
echo '| | | |/ _` / __| | | | |_ \ / _ \| |__| |'
echo '| |_| | (_| \__ \ |_| | | | | (_) | |  | |'
echo ' \__, |\__,_|___/\__,_|_| |_|\___/|_|  |_|'
echo ' |___/                                    '

echo -e "\n\n\n\n\n\n\n\n\n\n"

ln -snvf ~/dotfiles/home/.* ~/
ln -snvf ~/dotfiles/bin ~/
ln -snvf ~/dotfiles/config/* ~/.config/

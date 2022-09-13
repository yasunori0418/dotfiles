#!/bin/bash
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root."
  exit 1
fi

evacation_dir=/usr/local/share/vimfiles_evacation

etc_nvim_dir=/etc/xdg/nvim/
etc_nvim_evacation_dir=$evacation_dir/etc/xdg/

vim_dir=/usr/share/vim/vimfiles/plugin/
vim_evacation_dir=$evacation_dir/vim/vimfiles/

nvim_dir=/usr/share/nvim
nvim_evacation_dir=$evacation_dir/nvim

nvim_evacation_files=( \
  runtime/plugin/gzip.vim \
  runtime/plugin/health.vim \
  runtime/plugin/man.vim \
  runtime/plugin/matchit.vim \
  runtime/plugin/matchparen.vim \
  runtime/plugin/netrwPlugin.vim \
  runtime/plugin/shada.vim \
  runtime/plugin/spellfile.vim \
  runtime/plugin/tarPlugin.vim \
  runtime/plugin/tohtml.vim \
  runtime/plugin/tutor.vim \
  runtime/plugin/zipPlugin.vim \
  runtime/menu.vim \
  runtime/mswin.vim \
  archlinux.vim)

# Check exists evacation directory.
# When not exists make evacation directory.
if [ ! -d $evacation_dir ]; then
  mkdir -p $nvim_evacation_dir/runtime/plugin
  mkdir -p $vim_evacation_dir
  mkdir -p $etc_nvim_evacation_dir
fi

# XDG/nvim evacation directory
if [ -d $etc_nvim_dir ]; then
  mv $etc_nvim_dir $etc_nvim_evacation_dir
fi

# Vim evacation directory
if [ -d $vim_dir ]; then
  mv $vim_dir $vim_evacation_dir
fi

# Neovim evacation file
for vim_file in "${nvim_evacation_files[@]}"; do
  if [ -e ${nvim_dir%/}/${vim_file} ]; then
    mv $nvim_dir/$vim_file $nvim_evacation_dir/$vim_file
  fi
done

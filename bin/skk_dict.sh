#!/usr/bin/env bash

skk_dict_dir=${HOME}/.cache/skk_dict
skk_dir=${HOME}/.skk

if [[ ! $(command -v skkdic-expr2) ]]; then
  skktools.sh install
fi

if [[ ! -d ${skk_dict_dir} ]]; then
  git clone https://github.com/skk-dev/dict.git ${skk_dict_dir}
fi
cd ${skk_dict_dir}

[[ ! -d ${skk_dir} ]] && mkdir ${skk_dir}

skkdic-expr2 -o ${skk_dir}/skk_dict_merged SKK-JISYO.L +  SKK-JISYO.propernoun
cp ${skk_dict_dir}/SKK-JISYO.emoji ${skk_dir}/SKK-JISYO.emoji

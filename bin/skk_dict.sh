#!/usr/bin/env bash

# SKK Openlabメンテナンスの辞書
openlab_dict=${XDG_CACHE_HOME}/skk_dict
[[ ! -d ${openlab_dict} ]] && git clone https://github.com/skk-dev/dict.git ${openlab_dict}
cd ${openlab_dict}
git pull

# tokuhirom/jawiki-kana-kanji-dict 日本語wikipediaの内容をSKKの辞書化した物
jawiki_dict=${XDG_CACHE_HOME}/jawiki_dict
[[ ! -d ${jawiki_dict} ]] && git clone https://github.com/tokuhirom/jawiki-kana-kanji-dict.git ${jawiki_dict}
cd ${jawiki_dict}
git pull

skk_dir=${HOME}/.skk
[[ ! -d ${skk_dir} ]] && mkdir ${skk_dir}

cp ${openlab_dict}/SKK-JISYO.L ${skk_dir}/
cp ${openlab_dict}/SKK-JISYO.propernoun ${skk_dir}/
cp ${jawiki_dict}/SKK-JISYO.jawiki ${skk_dir}/
cp ${openlab_dict}/SKK-JISYO.emoji ${skk_dir}/

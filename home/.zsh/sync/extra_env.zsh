### extras environment variable ###

# if installed binary by rust-cargo
cargo_bin=${HOME}/.cargo/bin
if [[ -d ${cargo_bin} ]]; then
  PATH=${PATH}:${cargo_bin}
fi

# themis environment
themis_bin=${HOME}/.cache/dein/repos/github.com/thinca/vim-themis/bin
if [[ -d ${themis_bin} ]]; then
  PATH=${PATH}:${themis_bin}
fi

# go package
go_bin=${HOME}/go/bin
if [[ -d ${go_bin} ]]; then
  PATH=${PATH}:${go_bin}
fi

# bun package
bun_path=${HOME}/.cache/.bun
if [[ -d ${bun_path} ]]; then
  export BUN_INSTALL=${bun_path}
  PATH=${PATH}:${bun_path}/bin
fi

# npm package
npm_path=${HOME}/node_modules/.bin
if [[ -d ${bun_path} ]]; then
  PATH=${PATH}:${npm_path}
fi

# bat theme
export BAT_THEME=Nord

# diff-highlight
PATH=${PATH}:/usr/share/git/diff-highlight

# ヒストリの一覧を読みやすい形に変更
export HISTTIMEFORMAT="[%Y/%M/%D %H:%M:%S] "

# ヒストリーサイズ設定
export HISTFILE=${HOME}/.zhistory
export HISTSIZE=1000000
export SAVEHIST=1000000

# 補完リストが多いときに尋ねない
export LISTMAX=100

# "|,:"を単語の一部とみなさない
export WORDCHARS="${WORDCHARS}|,:"

# LS_COLORS
if [[ $(command -v vivid) ]];then
  export LS_COLORS="$(vivid generate nord)"
else
  dir_colors_cache=${XDG_CACHE_HOME}/dir_colors.zsh
  dir_colors=${HOME}/.dir_colors
  if [[ ! -r ${dir_colors_cache} || ${dir_colors} -nt ${dir_colors_cache} ]]; then
    dircolors ${dir_colors} > ${dir_colors_cache}
  fi
  source ${dir_colors_cache}
fi

unset dir_colors dir_colors_cache go_bin cargo_bin themis_bin
export PATH

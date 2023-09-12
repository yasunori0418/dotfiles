function ensure_zcompiled {
  local compiled=${1}.zwc
  if [[ ! -r ${compiled} || ${1} -nt ${compiled} ]]; then
    echo Comiling ${1}
    zcompile ${1}
  fi
}

function source {
  ensure_zcompiled ${1}
  builtin source ${1}
}

ensure_zcompiled ${HOME}/.zshrc
ensure_zcompiled ${HOME}/.zshenv


if [[ ! $(command -v sheldon) ]]; then
  curl --proto '=https' -fLsS https://rossmacarthur.github.io/install/crate.sh \
  | bash -s -- --repo rossmacarthur/sheldon --to ~/.local/bin
fi

eval "$(sheldon source)"

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

sheldon_cache=${XDG_CACHE_HOME}/sheldon.zsh
sheldon_toml=${XDG_CONFIG_HOME}/sheldon/plugins.toml

if [[ ! -r ${sheldon_cache} || ${sheldon_toml} -nt ${sheldon_cache} ]]; then
  sheldon source > ${sheldon_cache}
fi

source ${sheldon_cache}
unset sheldon_cache sheldon_toml
unfunction source

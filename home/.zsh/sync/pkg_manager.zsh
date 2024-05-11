# mise
mise_cache=${XDG_CACHE_HOME}/mise.zsh
if [[ ! -r ${mise_cache} || ${MISE_CONFIG_FILE} -nt ${mise_cache} ]]; then
  mise activate zsh > ${mise_cache}
fi
source ${mise_cache}

# devbox
devbox_cache="${XDG_CACHE_HOME}/devbox.zsh"
devbox_json="${XDG_DATA_HOME}/devbox/global/default/devbox.json"
if [[ -d /nix && $(command -v devbox) ]]; then
  if [[ ! -r ${devbox_cache} || ${devbox_json} -nt ${devbox_cache} ]]; then
    devbox global shellenv --init-hook > ${devbox_cache}
  fi
  source ${devbox_cache}
fi

unset devbox_cache devbox_json mise_cache

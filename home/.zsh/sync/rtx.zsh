# mise
mise_cache=${XDG_CACHE_HOME}/mise.zsh
if [[ ! -r ${mise_cache} || ${MISE_CONFIG_FILE} -nt ${mise_cache} ]]; then
  mise activate zsh > ${mise_cache}
fi
source ${mise_cache}

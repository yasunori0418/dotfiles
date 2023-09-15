# rtx
export PATH=${DOTFILES_DATA}/rtx/bin:${PATH}
export RTX_DATA_DIR=${HOME}/.rtx
export RTX_CACHE_DIR=${RTX_DATA_DIR}/cache
export RTX_CONFIG_FILE=${XDG_CONFIG_HOME}/rtx/config.toml

rtx_cache=${XDG_CACHE_HOME}/rtx.zsh
if [[ ! -r ${rtx_cache} || ${RTX_CONFIG_FILE} -nt ${rtx_cache} ]]; then
  rtx activate zsh > ${rtx_cache}
fi
source ${rtx_cache}

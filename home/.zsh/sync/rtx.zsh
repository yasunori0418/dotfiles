# rtx
rtx_cache=${XDG_CACHE_HOME}/rtx.zsh
if [[ ! -r ${rtx_cache} || ${RTX_CONFIG_FILE} -nt ${rtx_cache} ]]; then
  rtx activate zsh > ${rtx_cache}
fi
source ${rtx_cache}

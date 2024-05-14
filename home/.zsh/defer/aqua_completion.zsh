aqua_cache="${XDG_CACHE_HOME}/aqua_comp.zsh"
[[ ! -f ${aqua_cache} ]] && aqua completion zsh > ${aqua_cache}
source ${aqua_cache}

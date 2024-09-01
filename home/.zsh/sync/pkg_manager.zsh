# mise
mise_cache=${XDG_CACHE_HOME}/mise.zsh

if [[ $(uname -s) = 'Darwin' ]]; then
    if [[ ! -r ${mise_cache} || ${MISE_CONFIG_FILE} -nt ${mise_cache} ]]; then
        mise activate zsh > ${mise_cache}
    fi
    source ${mise_cache}
fi

unset mise_cache

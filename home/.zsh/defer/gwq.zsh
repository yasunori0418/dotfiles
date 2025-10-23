gwq_cache="${XDG_CACHE_HOME}/gwq.zsh"
dotfiles_flake_lock="${DOTFILES}/flake.lock"
if [[ ! -f ${gwq_cache} || ${dotfiles_flake_lock} -nt ${gwq_cache} ]]; then
    gwq completion zsh > ${gwq_cache}
fi
source ${gwq_cache}
unset gwq_cache dotfiles_flake_lock

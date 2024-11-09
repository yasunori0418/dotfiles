direnv_cache="${XDG_CACHE_HOME}/direnv.zsh"
dotfiles_flake_lock="${DOTFILES}/flake.lock"
if [[ ! -f ${direnv_cache} || ${dotfiles_flake_lock} -nt ${direnv_cache} ]]; then
    direnv hook zsh > ${direnv_cache}
fi
source ${direnv_cache}
unset direnv_cache dotfiles_flake_lock

# mise - polyglot runtime manager
mise_cache="${XDG_CACHE_HOME}/mise.zsh"
dotfiles_flake_lock="${DOTFILES}/flake.lock"
if [[ ! -f ${mise_cache} || ${dotfiles_flake_lock} -nt ${mise_cache} ]]; then
    mise activate zsh > ${mise_cache}
fi
source ${mise_cache}
unset mise_cache dotfiles_flake_lock

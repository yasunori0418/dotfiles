# tirith - terminal security guard (homograph URLs, pipe-to-shell, exfil, malicious AI configs)
tirith_cache="${XDG_CACHE_HOME}/tirith.zsh"
dotfiles_flake_lock="${DOTFILES}/flake.lock"
if [[ ! -f ${tirith_cache} || ${dotfiles_flake_lock} -nt ${tirith_cache} ]]; then
    tirith init --shell zsh > ${tirith_cache}
fi
source ${tirith_cache}
unset tirith_cache dotfiles_flake_lock

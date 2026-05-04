git_wt_cache="${XDG_CACHE_HOME}/git-wt.zsh"
dotfiles_flake_lock="${DOTFILES}/flake.lock"
if [[ ! -f ${git_wt_cache} || ${dotfiles_flake_lock} -nt ${git_wt_cache} ]]; then
    git-wt --init zsh > ${git_wt_cache}
fi
source ${git_wt_cache}
unset git_wt_cache dotfiles_flake_lock

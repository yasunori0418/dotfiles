# wt (worktrunk) - Git worktree management for parallel AI agent workflows
wt_cache="${XDG_CACHE_HOME}/wt.zsh"
dotfiles_flake_lock="${DOTFILES}/flake.lock"
if [[ ! -f ${wt_cache} || ${dotfiles_flake_lock} -nt ${wt_cache} ]]; then
    wt config shell init zsh > ${wt_cache}
fi
source ${wt_cache}
unset wt_cache dotfiles_flake_lock

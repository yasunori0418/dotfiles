# wt (worktrunk) - Git worktree management for parallel AI agent workflows
wt_cache="${XDG_CACHE_HOME}/wt.zsh"
dotfiles_flake_lock="${DOTFILES}/flake.lock"
if [[ ! -f ${wt_cache} || ${dotfiles_flake_lock} -nt ${wt_cache} ]]; then
    # Patch rm -f -> command rm -f before writing, so alias expansion at source
    # time doesn't intercept the temp file cleanup inside wt().
    wt config shell init zsh | sed 's/\brm -f\b/command rm -f/g' > ${wt_cache}
fi
source ${wt_cache}
unset wt_cache dotfiles_flake_lock

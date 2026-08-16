# wt (worktrunk) - Git worktree management for parallel AI agent workflows
wt_cache="${XDG_CACHE_HOME}/wt.zsh"
dotfiles_flake_lock="${DOTFILES}/flake.lock"
if [[ ! -f ${wt_cache} || ${dotfiles_flake_lock} -nt ${wt_cache} ]]; then
    # NOTE: worktrunk itself emits `command rm -f` for the temp file cleanup
    # inside wt(), so the `rm` alias in aliases.zsh is already bypassed. No
    # patching needed here (a `command` prefix patch would double up and break).
    wt config shell init zsh > ${wt_cache}
fi
source ${wt_cache}
unset wt_cache dotfiles_flake_lock

# zoxide - smarter cd command with directory history tracking
zoxide_cache="${XDG_CACHE_HOME}/zoxide.zsh"
dotfiles_flake_lock="${DOTFILES}/flake.lock"
if [[ ! -f ${zoxide_cache} || ${dotfiles_flake_lock} -nt ${zoxide_cache} ]]; then
    zoxide init zsh > ${zoxide_cache}
fi
source ${zoxide_cache}
unset zoxide_cache dotfiles_flake_lock

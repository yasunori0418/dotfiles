# ls command aliases.
if [[ $(command -v eza) ]]; then
    alias eza='eza --icons -F'
    alias ls='eza'
    alias ll='eza -l --git'
    alias la='ll -a'
    alias lt='eza -T -L 3 -a -I ".git|.atom|.cache" --color=always'
    alias ltl='lt | less'
    alias lal='la --color=always | less'
else
    alias ls='ls --color=always'
    alias la='ls -laA'
    alias ll='ls -lA'
    alias la='ls -laA | less'
fi

# cd command aliases
alias cdc=custom_cd # ./commands.zsh
alias dotfiles='cd ~/dotfiles'
alias dotnvim='cd ~/dotfiles/home/.config/nvim'
alias dotvim='cd ~/dotfiles/home/.config/vim'
alias cdr=git_root # ./commands.zsh

# rm command disable
[[ $(command -v rip) ]] && alias rm="echo Use 'rip' instead of rm."

# Neovim alias
[[ $(command -v nvim) ]] && alias nv=nvim_server_pipe # ./commands.zsh
[[ $(command -v nvr) && -n "${NVIM}" ]] && alias nv='nvr -cc "if nvim_win_get_config(0).relative != \"\" | quit | endif" --remote'
[[ $(command -v neovide) ]] && alias nvg='neovide'

# useful command aliases
alias sync_status='watch grep -e Dirty: -e Writeback: /proc/meminfo'
alias capswap='systemctl --user restart xremap.service'

[[ $(command -v colordiff) ]] && alias diff='colordiff'

# aws profile switch
alias awsp='export AWS_PROFILE=$(aws configure list-profiles | fzf) && aws sso login'

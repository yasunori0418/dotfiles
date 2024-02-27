# ls command aliases.
if [[ $(command -v eza) ]]; then
  alias eza='eza --icons -F'
  alias ls='eza'
  alias ll='eza -l --git'
  alias la='ll -a'
  alias lt='eza -T -L 3 -a -I ".git|.atom|.cache" --color=always | less'
  alias lal='la --color=always | less'
else
  alias ls='ls --color=always'
  alias la='ls -laA'
  alias ll='ls -lA'
  alias la='ls -laA | less'
fi

# clear command aliases.
alias c='clear'
alias cc='c &&'

# cd command aliases
alias cd=custom_cd # ./commands.zsh
alias dotfiles='cd ~/dotfiles'

# Neovim alias
if [[ $(command -v nvim) ]]; then
  alias nv='nvim --listen ~/.cache/nvim/server.pipe'
  alias nvr='nvim --server ~/.cache/nvim/server.pipe --remote'
  alias nvrt='nvim --server ~/.cache/nvim/server.pipe --remote-tab'
fi

if [[ $(command -v neovide) ]]; then
  alias nvg='neovide --multigrid'
fi

# useful command aliases
alias sync_status='watch grep -e Dirty: -e Writeback: /proc/meminfo'
alias capswap='systemctl --user start swap_caps_k8.service'

[[ $(command -v colordiff) ]] && alias diff='colordiff'

alias ggh='~/src/github.com/yasunori0418/cli/bin/gh'

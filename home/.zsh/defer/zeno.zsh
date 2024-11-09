# zeno.zsh

# Ref: https://uki00a.github.io/deno-weekly/articles/deno/v1.27.html
export DENO_NO_UPDATE_CHECK=1

# git file preview with color
export ZENO_GIT_CAT="bat --color=always"

# git folder preview with color
export ZENO_GIT_TREE="exa --tree"

# if disable builtin completion
# export ZENO_DISABLE_BUILTIN_COMPLETION=1

export ZENO_ENABLE_SOCK=1

# zeno keybinds
if [[ $(command -v deno) && ${ZENO_LOADED} ]]; then
    bindkey " "  zeno-auto-snippet
    bindkey "^I" zeno-completion
    bindkey "^R" zeno-history-selection
    bindkey '^X' zeno-insert-snippet
    bindkey '^G' zeno-ghq-cd
fi

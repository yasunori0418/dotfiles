# zeno.zsh

# Ref: https://uki00a.github.io/deno-weekly/articles/deno/v1.27.html
export DENO_NO_UPDATE_CHECK=1

# git file preview with color
export ZENO_GIT_CAT="bat --color=always"

# git folder preview with color
export ZENO_GIT_TREE="exa --tree"

# if disable builtin completion
# export ZENO_DISABLE_BUILTIN_COMPLETION=1

# zeno keybinds
if [[ $(command -v deno) && ${ZENO_LOADED} ]]; then
    # abbrev snippet
    bindkey " "  zeno-auto-snippet
    # bindkey "^M" zeno-auto-snippet-and-accept-line

    # fallback bindkey
    bindkey "^X^M" accept-line
    bindkey "^XM" accept-line
    bindkey "^X^ " zeno-insert-space
    bindkey "^X " zeno-insert-space

    # completion
    bindkey "^I" zeno-completion

    # ZLE wigets
    bindkey "^R" zeno-history-selection
    bindkey '^X^S' zeno-insert-snippet
    bindkey '^X^F' zeno-ghq-cd
fi

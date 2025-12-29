# zeno.zsh

# Ref: https://uki00a.github.io/deno-weekly/articles/deno/v1.27.html
export DENO_NO_UPDATE_CHECK=1

# git file preview with color
export ZENO_GIT_CAT="bat --color=always"

# git folder preview with color
export ZENO_GIT_TREE="exa --tree"

# if disable builtin completion
# export ZENO_DISABLE_BUILTIN_COMPLETION=1

# if enable fzf-tmux
export ZENO_ENABLE_FZF_TMUX=1

# if setting fzf-tmux options
export ZENO_FZF_TMUX_OPTIONS="-p"

# zeno keybinds
if [[ $(command -v deno) && ${ZENO_LOADED} ]]; then
    # abbrev snippet
    bindkey " "  zeno-auto-snippet

    # bindkey "^M" accept-line
    bindkey "^X^M" zeno-auto-snippet-and-accept-line

    # fallback bindkey
    bindkey "^X^ " zeno-insert-space

    # completion
    bindkey "^I" zeno-completion

    # ZLE wigets
    bindkey "^R" zeno-smart-history-selection
    bindkey '^X^X' zeno-insert-snippet
    bindkey '^X^F' zeno-ghq-cd

    # preprompt bindings
    bindkey '^X^P' zeno-preprompt
    bindkey '^X^S' zeno-preprompt-snippet
    # Outside ZLE you can run `zeno-preprompt git {{cmd}}` or `zeno-preprompt-snippet foo`
    # to set the next prompt prefix; invoking them with an empty argument resets the state.

fi
